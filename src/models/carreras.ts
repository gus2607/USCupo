import { supabase } from '../lib/supabase';
import type { Carrera } from './types';

export async function listarCarreras(): Promise<Carrera[]> {
  const { data, error } = await supabase
    .from('carreras')
    .select('*')
    .eq('activa', true)
    .order('facultad')
    .order('nombre');

  if (error) throw error;
  return data as Carrera[];
}
