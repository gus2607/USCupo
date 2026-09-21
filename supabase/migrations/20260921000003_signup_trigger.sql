-- USCupo · alta de perfil al registrarse + verificación de dominio institucional en el
-- servidor (defensa en profundidad: la validación del formulario se puede saltar, esta no).

create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if new.email is null or new.email !~* '^[^@]+@usc\.edu\.co$' then
    raise exception 'USCupo es solo para correos institucionales @usc.edu.co';
  end if;

  insert into public.profiles (id, nombre_completo, correo, carrera_id)
    values (
      new.id,
      coalesce(new.raw_user_meta_data ->> 'nombre_completo', split_part(new.email, '@', 1)),
      new.email,
      nullif(new.raw_user_meta_data ->> 'carrera_id', '')::bigint
    );

  return new;
end;
$$;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();
