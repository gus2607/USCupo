import { View } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { Text } from 'react-native';
import { useTheme } from '../theme/useTheme';

export function ProximamenteScreen({ titulo }: { titulo: string }) {
  const { colors, spacing, type } = useTheme();

  return (
    <SafeAreaView style={{ flex: 1, backgroundColor: colors.background }}>
      <View style={{ flex: 1, alignItems: 'center', justifyContent: 'center', padding: spacing.lg }}>
        <Text style={[type.sectionTitle, { color: colors.text, marginBottom: spacing.sm }]}>{titulo}</Text>
        <Text style={[type.bodyMuted, { color: colors.textMuted, textAlign: 'center' }]}>
          Esta pantalla llega en la siguiente iteración.
        </Text>
      </View>
    </SafeAreaView>
  );
}
