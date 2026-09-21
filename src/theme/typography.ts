export const fonts = {
  heading: 'Poppins_600SemiBold',
  body: 'Inter_400Regular',
  bodyBold: 'Inter_700Bold',
} as const;

export const typeScale = {
  screenTitle: { fontFamily: fonts.heading, fontSize: 28, lineHeight: 34 },
  sectionTitle: { fontFamily: fonts.heading, fontSize: 20, lineHeight: 26 },
  cardTitle: { fontFamily: fonts.heading, fontSize: 16, lineHeight: 22 },
  body: { fontFamily: fonts.body, fontSize: 16, lineHeight: 22 },
  bodyMuted: { fontFamily: fonts.body, fontSize: 13.5, lineHeight: 18 },
  badge: { fontFamily: fonts.bodyBold, fontSize: 11, letterSpacing: 0.6 },
} as const;
