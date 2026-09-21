import { useEffect, useState } from 'react';
import {
  KeyboardAvoidingView,
  Platform,
  Pressable,
  ScrollView,
  StyleSheet,
  Text,
  View,
} from 'react-native';
import { Button } from '../../src/components/Button';
import { CarreraPicker } from '../../src/components/CarreraPicker';
import { InfoNotice } from '../../src/components/InfoNotice';
import { Logo } from '../../src/components/Logo';
import { SegmentedControl } from '../../src/components/SegmentedControl';
import { TextField } from '../../src/components/TextField';
import { esCorreoInstitucional, iniciarSesion, iniciarSesionConGoogle, registrarse } from '../../src/controllers/auth';
import { listarCarreras } from '../../src/models/carreras';
import type { Carrera } from '../../src/models/types';
import { useTheme } from '../../src/theme/useTheme';
import { USC_EMAIL_DOMAIN } from '../../src/lib/supabase';

export default function LoginScreen() {
  const { colors, spacing, type } = useTheme();
  const [modo, setModo] = useState<0 | 1>(0); // 0 = crear cuenta, 1 = iniciar sesión

  const [carreras, setCarreras] = useState<Carrera[]>([]);
  const [nombreCompleto, setNombreCompleto] = useState('');
  const [correo, setCorreo] = useState('');
  const [contrasena, setContrasena] = useState('');
  const [carrera, setCarrera] = useState<Carrera | null>(null);

  const [loading, setLoading] = useState(false);
  const [googleLoading, setGoogleLoading] = useState(false);
  const [correoError, setCorreoError] = useState<string | undefined>();
  const [carreraError, setCarreraError] = useState<string | undefined>();
  const [formError, setFormError] = useState<string | undefined>();
  const [avisoConfirmacion, setAvisoConfirmacion] = useState(false);

  useEffect(() => {
    listarCarreras()
      .then(setCarreras)
      .catch((e) => setFormError(e.message));
  }, []);

  function validarCorreo(valor: string) {
    if (valor.length > 0 && !esCorreoInstitucional(valor)) {
      setCorreoError(`Usa tu correo institucional, terminado en @${USC_EMAIL_DOMAIN}`);
    } else {
      setCorreoError(undefined);
    }
  }

  async function onSubmit() {
    setFormError(undefined);
    setAvisoConfirmacion(false);

    if (!esCorreoInstitucional(correo)) {
      setCorreoError(`Usa tu correo institucional, terminado en @${USC_EMAIL_DOMAIN}`);
      return;
    }
    if (modo === 0 && !carrera) {
      setCarreraError('Elige tu carrera para continuar');
      return;
    }

    setLoading(true);
    try {
      if (modo === 0) {
        const { session } = await registrarse({
          nombreCompleto,
          correo,
          contrasena,
          carreraId: carrera!.id,
        });
        if (!session) setAvisoConfirmacion(true);
      } else {
        await iniciarSesion(correo, contrasena);
      }
    } catch (e: any) {
      setFormError(e.message ?? 'Ocurrió un error, intenta de nuevo.');
    } finally {
      setLoading(false);
    }
  }

  async function onGoogle() {
    setFormError(undefined);
    setGoogleLoading(true);
    try {
      await iniciarSesionConGoogle();
    } catch (e: any) {
      setFormError(e.message ?? 'No se pudo continuar con Google.');
    } finally {
      setGoogleLoading(false);
    }
  }

  return (
    <KeyboardAvoidingView
      style={{ flex: 1, backgroundColor: colors.background }}
      behavior={Platform.OS === 'ios' ? 'padding' : undefined}
    >
      <ScrollView contentContainerStyle={{ padding: spacing.lg, paddingTop: spacing.xxl }} keyboardShouldPersistTaps="handled">
        <View style={styles.header}>
          <Logo size={40} />
          <View style={{ marginLeft: spacing.sm }}>
            <Text style={[type.sectionTitle, { color: colors.text }]}>USCupo</Text>
            <Text style={[type.bodyMuted, { color: colors.textMuted }]}>Cambios de horario entre estudiantes USC</Text>
          </View>
        </View>

        <View style={{ marginTop: spacing.lg }}>
          <SegmentedControl
            options={['Crear cuenta', 'Iniciar sesión']}
            selectedIndex={modo}
            onChange={(index) => {
              setModo(index);
              setFormError(undefined);
              setAvisoConfirmacion(false);
            }}
          />
        </View>

        <View style={{ marginTop: spacing.lg }}>
          <Text style={[type.screenTitle, { color: colors.text, fontSize: 22 }]}>
            {modo === 0 ? 'Crea tu cuenta' : 'Inicia sesión'}
          </Text>
          <Text style={[type.bodyMuted, { color: colors.textMuted, marginBottom: spacing.md }]}>
            Solo estudiantes con correo institucional @{USC_EMAIL_DOMAIN}
          </Text>

          {modo === 0 && (
            <TextField
              label="Nombre completo"
              placeholder="Andrea Salazar"
              value={nombreCompleto}
              onChangeText={setNombreCompleto}
              autoCapitalize="words"
            />
          )}

          <TextField
            label="Correo institucional"
            placeholder={`tu.nombre@${USC_EMAIL_DOMAIN}`}
            value={correo}
            onChangeText={(v) => {
              setCorreo(v);
              if (correoError) validarCorreo(v);
            }}
            onBlur={() => validarCorreo(correo)}
            error={correoError}
            autoCapitalize="none"
            autoCorrect={false}
            keyboardType="email-address"
          />

          {modo === 0 && (
            <CarreraPicker
              label="Carrera"
              carreras={carreras}
              selectedId={carrera?.id ?? null}
              onSelect={(c) => {
                setCarrera(c);
                setCarreraError(undefined);
              }}
              error={carreraError}
            />
          )}

          <TextField
            label="Contraseña"
            placeholder="Mínimo 8 caracteres"
            value={contrasena}
            onChangeText={setContrasena}
            secureTextEntry
            autoCapitalize="none"
          />

          {formError && (
            <Text style={[type.bodyMuted, { color: colors.danger, marginBottom: spacing.md }]}>{formError}</Text>
          )}
          {avisoConfirmacion && (
            <InfoNotice>Cuenta creada. Revisa tu correo institucional para confirmarla antes de iniciar sesión.</InfoNotice>
          )}

          <Button
            label={modo === 0 ? 'Crear cuenta' : 'Iniciar sesión'}
            loadingLabel={modo === 0 ? 'Creando cuenta…' : 'Iniciando sesión…'}
            onPress={onSubmit}
            loading={loading}
          />

          <Pressable onPress={() => setModo(modo === 0 ? 1 : 0)} style={{ marginTop: spacing.md, alignItems: 'center' }}>
            <Text style={[type.bodyMuted, { color: colors.textMuted }]}>
              {modo === 0 ? '¿Ya tienes cuenta? ' : '¿No tienes cuenta? '}
              <Text style={{ color: colors.primary, fontFamily: 'Inter_700Bold' }}>
                {modo === 0 ? 'Inicia sesión' : 'Crear cuenta'}
              </Text>
            </Text>
          </Pressable>

          <View style={[styles.divider, { borderColor: colors.border }]}>
            <View style={[styles.dividerLine, { backgroundColor: colors.border }]} />
            <Text style={[type.bodyMuted, { color: colors.textMuted, marginHorizontal: spacing.sm }]}>o</Text>
            <View style={[styles.dividerLine, { backgroundColor: colors.border }]} />
          </View>

          <Button label="Continuar con Google" variant="secondary" onPress={onGoogle} loading={googleLoading} />

          <View style={{ marginTop: spacing.lg }}>
            <InfoNotice>
              USCupo solo conecta estudiantes. La gestión del cambio de horario se hace directamente en los canales
              oficiales de la USC.
            </InfoNotice>
          </View>
        </View>
      </ScrollView>
    </KeyboardAvoidingView>
  );
}

const styles = StyleSheet.create({
  header: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  divider: {
    flexDirection: 'row',
    alignItems: 'center',
    marginVertical: 16,
  },
  dividerLine: {
    flex: 1,
    height: StyleSheet.hairlineWidth,
  },
});
