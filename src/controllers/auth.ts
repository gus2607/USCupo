import * as Linking from 'expo-linking';
import { supabase, USC_EMAIL_DOMAIN } from '../lib/supabase';

const domainPattern = new RegExp(`^[^@\\s]+@${USC_EMAIL_DOMAIN.replace('.', '\\.')}$`, 'i');

export function esCorreoInstitucional(correo: string): boolean {
  return domainPattern.test(correo.trim());
}

export interface DatosRegistro {
  nombreCompleto: string;
  correo: string;
  contrasena: string;
  carreraId: number;
}

export async function registrarse({ nombreCompleto, correo, contrasena, carreraId }: DatosRegistro) {
  if (!esCorreoInstitucional(correo)) {
    throw new Error(`Usa tu correo institucional, terminado en @${USC_EMAIL_DOMAIN}`);
  }

  const { data, error } = await supabase.auth.signUp({
    email: correo.trim(),
    password: contrasena,
    options: {
      data: {
        nombre_completo: nombreCompleto.trim(),
        carrera_id: String(carreraId),
      },
    },
  });

  if (error) throw error;
  return data;
}

export async function iniciarSesion(correo: string, contrasena: string) {
  const { data, error } = await supabase.auth.signInWithPassword({
    email: correo.trim(),
    password: contrasena,
  });

  if (error) throw error;
  return data;
}

export async function iniciarSesionConGoogle() {
  const redirectTo = Linking.createURL('auth/callback');
  const { data, error } = await supabase.auth.signInWithOAuth({
    provider: 'google',
    options: {
      redirectTo,
      // Restringe el picker de cuentas de Google al dominio institucional. La USC debe
      // tener Google Workspace habilitado para @usc.edu.co para que esto tenga efecto;
      // el trigger de base de datos igual rechaza cualquier otro dominio.
      queryParams: { hd: USC_EMAIL_DOMAIN },
    },
  });

  if (error) throw error;
  return data;
}

export async function cerrarSesion() {
  const { error } = await supabase.auth.signOut();
  if (error) throw error;
}
