// Tokens semánticos tomados del design system de USCupo (mockups iPhone 16, 2026-09-17).
// El modo oscuro es un cambio de tema, no un rediseño: mismos nombres, distinto valor.

export const lightColors = {
  primary: '#004B87',
  primaryTint: '#E3EEF8',
  accent: '#146C43',
  accentTint: '#DFF3E7',
  danger: '#B3271E',
  background: '#F5F8FC',
  surface: '#FFFFFF',
  text: '#16212C',
  textMuted: '#5B6B7A',
  border: '#DCE4EC',
} as const;

export const darkColors = {
  primary: '#5AA6E0',
  primaryTint: '#173049',
  accent: '#3ED996',
  accentTint: '#0F3327',
  danger: '#F2887E',
  background: '#0E1720',
  surface: '#16212C',
  text: '#EAF1F8',
  textMuted: '#93A3B2',
  border: '#243040',
} as const;

// Marca: azul #073D6C y verde #21A14E en el símbolo de flechas.
export const brand = {
  logoBlue: '#073D6C',
  logoGreen: '#21A14E',
} as const;

export type ThemeColors = typeof lightColors;
