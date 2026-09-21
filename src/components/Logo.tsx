import Svg, { Path } from 'react-native-svg';
import { brand } from '../theme/colors';

// Dos flechas circulares que se intercambian: azul #073D6C y verde #21A14E (marca oficial).
export function Logo({ size = 40 }: { size?: number }) {
  return (
    <Svg width={size} height={size} viewBox="0 0 40 40" fill="none">
      <Path
        d="M20 6a14 14 0 0 1 13.86 12h-4.06A10 10 0 0 0 20 10V6Z"
        fill={brand.logoBlue}
      />
      <Path d="M33.86 18 30 24l-3.5-6.6 7.36.6Z" fill={brand.logoBlue} />
      <Path
        d="M20 34A14 14 0 0 1 6.14 22h4.06A10 10 0 0 0 20 30v4Z"
        fill={brand.logoGreen}
      />
      <Path d="M6.14 22 10 15.4l3.5 6.6-7.36-.6Z" fill={brand.logoGreen} />
    </Svg>
  );
}
