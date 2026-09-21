import { useMemo, useState } from 'react';
import { FlatList, Modal, Pressable, StyleSheet, Text, View } from 'react-native';
import { useTheme } from '../theme/useTheme';
import type { Carrera } from '../models/types';
import { TextField } from './TextField';

interface Props {
  label: string;
  carreras: Carrera[];
  selectedId: number | null;
  onSelect: (carrera: Carrera) => void;
  error?: string;
}

export function CarreraPicker({ label, carreras, selectedId, onSelect, error }: Props) {
  const { colors, radius, spacing, type, minTouchSize } = useTheme();
  const [open, setOpen] = useState(false);
  const [busqueda, setBusqueda] = useState('');

  const seleccionada = carreras.find((c) => c.id === selectedId) ?? null;

  const filtradas = useMemo(() => {
    const q = busqueda.trim().toLowerCase();
    if (!q) return carreras;
    return carreras.filter((c) => c.nombre.toLowerCase().includes(q) || c.facultad.toLowerCase().includes(q));
  }, [busqueda, carreras]);

  return (
    <View style={{ marginBottom: spacing.md }}>
      <Text style={[type.bodyMuted, { color: colors.text, fontFamily: 'Inter_700Bold', marginBottom: spacing.xs }]}>
        {label}
      </Text>
      <Pressable
        accessibilityRole="button"
        onPress={() => setOpen(true)}
        style={[
          styles.trigger,
          {
            minHeight: minTouchSize,
            borderRadius: radius.control,
            borderColor: error ? colors.danger : colors.border,
            backgroundColor: colors.surface,
          },
        ]}
      >
        <Text style={[type.body, { color: seleccionada ? colors.text : colors.textMuted }]}>
          {seleccionada ? seleccionada.nombre : 'Elige tu carrera'}
        </Text>
        <Text style={{ color: colors.textMuted }}>▾</Text>
      </Pressable>
      {error ? (
        <Text style={[type.bodyMuted, { color: colors.danger, marginTop: spacing.xs }]}>{error}</Text>
      ) : null}

      <Modal visible={open} animationType="slide" onRequestClose={() => setOpen(false)}>
        <View style={[styles.modal, { backgroundColor: colors.background, paddingTop: spacing.xxl }]}>
          <Text style={[type.sectionTitle, { color: colors.text, paddingHorizontal: spacing.lg }]}>
            ¿En qué carrera estás matriculado/a?
          </Text>
          <View style={{ paddingHorizontal: spacing.lg }}>
            <TextField
              label="Buscar"
              placeholder="Ingeniería, Derecho, Psicología…"
              value={busqueda}
              onChangeText={setBusqueda}
            />
          </View>
          <FlatList
            data={filtradas}
            keyExtractor={(item) => String(item.id)}
            contentContainerStyle={{ paddingHorizontal: spacing.lg, paddingBottom: spacing.xxl }}
            renderItem={({ item }) => {
              const active = item.id === selectedId;
              return (
                <Pressable
                  accessibilityRole="radio"
                  accessibilityState={{ checked: active }}
                  onPress={() => {
                    onSelect(item);
                    setOpen(false);
                    setBusqueda('');
                  }}
                  style={[
                    styles.option,
                    {
                      minHeight: minTouchSize,
                      borderRadius: radius.control,
                      borderColor: active ? colors.primary : colors.border,
                      backgroundColor: active ? colors.primaryTint : colors.surface,
                    },
                  ]}
                >
                  <View>
                    <Text style={[type.body, { color: colors.text }]}>{item.nombre}</Text>
                    <Text style={[type.bodyMuted, { color: colors.textMuted }]}>
                      {item.facultad} · {item.sede}
                    </Text>
                  </View>
                </Pressable>
              );
            }}
          />
        </View>
      </Modal>
    </View>
  );
}

const styles = StyleSheet.create({
  trigger: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    borderWidth: 1,
    paddingHorizontal: 14,
  },
  modal: {
    flex: 1,
  },
  option: {
    borderWidth: 1,
    justifyContent: 'center',
    paddingHorizontal: 14,
    paddingVertical: 10,
    marginBottom: 8,
  },
});
