import { StyleSheet, Text, TextInput, TextInputProps, View } from 'react-native';
import { useTheme } from '../theme/useTheme';

interface Props extends TextInputProps {
  label: string;
  error?: string;
}

export function TextField({ label, error, style, ...rest }: Props) {
  const { colors, radius, spacing, type, minTouchSize } = useTheme();

  return (
    <View style={{ marginBottom: spacing.md }}>
      <Text style={[type.bodyMuted, { color: colors.text, fontFamily: 'Inter_700Bold', marginBottom: spacing.xs }]}>
        {label}
      </Text>
      <TextInput
        placeholderTextColor={colors.textMuted}
        style={[
          type.body,
          styles.input,
          {
            minHeight: minTouchSize,
            borderRadius: radius.control,
            borderColor: error ? colors.danger : colors.border,
            backgroundColor: colors.surface,
            color: colors.text,
          },
          style,
        ]}
        {...rest}
      />
      {error ? (
        <Text style={[type.bodyMuted, { color: colors.danger, marginTop: spacing.xs }]}>{error}</Text>
      ) : null}
    </View>
  );
}

const styles = StyleSheet.create({
  input: {
    borderWidth: 1,
    paddingHorizontal: 14,
  },
});
