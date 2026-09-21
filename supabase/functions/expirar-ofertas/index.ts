// USCupo · Edge Function programada (cron diario recomendado: 0 3 * * *).
// Si nadie confirma el cambio dentro de los 7 días siguientes a que alguien mostró
// interés, la oferta se marca expirada y se elimina de la bolsa activa.
//
// Programar con: supabase functions deploy expirar-ofertas
//                 y un cron job en el dashboard (Database > Cron Jobs) que llame
//                 a esta función, o pg_cron + pg_net apuntando a su URL.

import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';

Deno.serve(async () => {
  const supabase = createClient(
    Deno.env.get('SUPABASE_URL')!,
    Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
  );

  const { data: vencidas, error: selectError } = await supabase
    .from('ofertas')
    .select('id, user_id, interesado_id')
    .eq('estado', 'en_proceso')
    .lt('expires_at', new Date().toISOString());

  if (selectError) {
    return new Response(JSON.stringify({ error: selectError.message }), { status: 500 });
  }
  if (!vencidas || vencidas.length === 0) {
    return new Response(JSON.stringify({ expiradas: 0 }), { status: 200 });
  }

  const ids = vencidas.map((o) => o.id);

  const { error: updateError } = await supabase
    .from('ofertas')
    .update({ estado: 'expirada' })
    .in('id', ids);

  if (updateError) {
    return new Response(JSON.stringify({ error: updateError.message }), { status: 500 });
  }

  const notificaciones = vencidas.map((o) => ({
    user_id: o.user_id,
    oferta_id: o.id,
    tipo: 'oferta_expirada',
  }));
  await supabase.from('notificaciones').insert(notificaciones);

  await supabase.from('ofertas').delete().in('id', ids);

  return new Response(JSON.stringify({ expiradas: ids.length }), { status: 200 });
});
