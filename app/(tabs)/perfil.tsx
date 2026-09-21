import { View } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { Text } from 'react-native';
import { Button } from '../../src/components/Button';
import { cerrarSesion } from '../../src/controllers/auth';
import { useAuth } from '../../src/lib/AuthContext';
import { useTheme } from '../../src/theme/useTheme';

export default function PerfilScreen() {
  const { colors, spacing, type } = useTheme();
  const { session } = useAuth();

  return (
    <SafeAreaView style={{ flex: 1, backgroundColor: colors.background }}>
      <View style={{ flex: 1, padding: spacing.lg }}>
        <Text style={[type.sectionTitle, { color: colors.text, marginBottom: spacing.xs }]}>
          {session?.user.user_metadata?.nombre_completo ?? 'Tu perfil'}
        </Text>
        <Text style={[type.bodyMuted, { color: colors.textMuted, marginBottom: spacing.xl }]}>
          {session?.user.email}
        </Text>
        <Button label="Cerrar sesión" variant="secondary" onPress={cerrarSesion} />
      </View>
    </SafeAreaView>
  );
}
