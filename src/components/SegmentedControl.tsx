import { Pressable, StyleSheet, Text, View } from 'react-native';
import { useTheme } from '../theme/useTheme';

interface Props {
  options: [string, string];
  selectedIndex: 0 | 1;
  onChange: (index: 0 | 1) => void;
}

export function SegmentedControl({ options, selectedIndex, onChange }: Props) {
  const { colors, radius, minTouchSize } = useTheme();

  return (
    <View style={[styles.track, { backgroundColor: colors.primaryTint, borderRadius: radius.control }]}>
      {options.map((label, index) => {
        const selected = index === selectedIndex;
        return (
          <Pressable
            key={label}
            accessibilityRole="tab"
            accessibilityState={{ selected }}
            onPress={() => onChange(index as 0 | 1)}
            style={[
              styles.segment,
              {
                minHeight: minTouchSize - 8,
                borderRadius: radius.control - 2,
                backgroundColor: selected ? colors.surface : 'transparent',
              },
            ]}
          >
            <Text
              style={{
                fontFamily: 'Inter_700Bold',
                fontSize: 15,
                color: selected ? colors.primary : colors.textMuted,
              }}
            >
              {label}
            </Text>
          </Pressable>
        );
      })}
    </View>
  );
}

const styles = StyleSheet.create({
  track: {
    flexDirection: 'row',
    padding: 4,
  },
  segment: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
});
