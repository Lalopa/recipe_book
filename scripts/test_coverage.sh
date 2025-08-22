#!/bin/bash

echo "🧪 Ejecutando tests con coverage..."

# Limpiar coverage anterior
rm -rf coverage/

# Ejecutar tests con coverage
flutter test --coverage

# Generar reporte HTML
genhtml coverage/lcov.info -o coverage/html

echo "✅ Tests completados!"
echo "📊 Reporte de coverage generado en: coverage/html/index.html"
echo "📈 Archivo LCOV generado en: coverage/lcov.info"

# Mostrar resumen de coverage
lcov --summary coverage/lcov.info
