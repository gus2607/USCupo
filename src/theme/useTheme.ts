import { useColorScheme } from 'react-native';
import { darkColors, lightColors } from './colors';
import { spacing, radius, minTouchSize } from './spacing';
import { typeScale } from './typography';

export function useTheme() {
  const scheme = useColorScheme();
  const colors = scheme === 'dark' ? darkColors : lightColors;
  return { colors, spacing, radius, minTouchSize, type: typeScale, scheme: scheme ?? 'light' };
}
