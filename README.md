# Recipe Book 📚

Una aplicación móvil de recetas de cocina desarrollada en Flutter que permite a los usuarios buscar, visualizar y guardar sus recetas favoritas.

## 🏗️ Enfoque Arquitectónico

Este proyecto sigue una **arquitectura limpia (Clean Architecture)** con **Domain-Driven Design (DDD)** implementada en Flutter:

### Estructura del Proyecto
- **`lib/core/`**: Capa de infraestructura compartida (inyección de dependencias, configuración, utilidades)
- **`lib/features/`**: Módulos de características organizados por dominio
  - **`meals/`**: Gestión de recetas (búsqueda, visualización, API)
  - **`favorites/`**: Sistema de favoritos con persistencia local
  - **`search/`**: Funcionalidad de búsqueda de recetas
  - **`main/`**: Navegación principal de la aplicación

### Patrones de Diseño Implementados
- **BLoC Pattern** para gestión de estado reactivo
- **Repository Pattern** para abstracción de datos
- **Dependency Injection** con GetIt e Injectable
- **Freezed** para modelos inmutables y generación de código
- **ObjectBox** para persistencia local de datos

### Tecnologías y Librerías
- **Estado**: Flutter BLoC para gestión de estado
- **Redes**: Dio para llamadas HTTP a APIs
- **Base de Datos Local**: ObjectBox para cache y favoritos
- **Inyección de Dependencias**: GetIt + Injectable
- **Generación de Código**: Freezed, JSON Serializable, Build Runner

## 🚀 Instalación y Configuración Local

### Prerrequisitos
- Flutter SDK 3.9.0 o superior
- Dart SDK 3.9.0 o superior
- Android Studio / Xcode (para desarrollo móvil)
- Git

### Pasos de Instalación

1. **Clonar el repositorio**
   ```bash
   git clone <repository-url>
   cd recipe_book
   ```

2. **Instalar dependencias de Flutter**
   ```bash
   flutter pub get
   ```

3. **Generar código necesario**
   ```bash
   # Generar modelos Freezed y ObjectBox
   flutter packages pub run build_runner build --delete-conflicting-outputs
   
   # O ejecutar en modo watch para desarrollo
   flutter packages pub run build_runner watch
   ```

4. **Configurar ObjectBox (solo primera vez)**
   ```bash
   # Generar archivos de ObjectBox
   flutter packages pub run objectbox_generator
   ```

5. **Ejecutar la aplicación**
   ```bash
   # Para desarrollo
   flutter run
   
   # Para release
   flutter run --release
   ```

### Configuración de Entorno de Desarrollo

1. **Instalar hooks de Git (opcional pero recomendado)**
   ```bash
   # Configurar Husky para validación de commits
   npx husky install
   ```

2. **Ejecutar tests**
   ```bash
   # Tests unitarios
   flutter test
   
   # Tests con coverage
   flutter test --coverage
   ```

## 🔧 Configuración Adicional

### Variables de Entorno
La aplicación utiliza la API de [TheMealDB](https://www.themealdb.com/) para obtener recetas. No se requieren API keys para uso básico.

### Configuración de Dispositivos
- **Android**: API level 21+ (Android 5.0+)
- **iOS**: iOS 12.0+

## 📱 Funcionalidades Principales

- **Búsqueda de Recetas**: Interfaz de búsqueda con resultados en tiempo real
- **Visualización de Recetas**: Páginas detalladas con imágenes, ingredientes e instrucciones
- **Sistema de Favoritos**: Guardado local de recetas favoritas con ObjectBox
- **Cache Inteligente**: Almacenamiento local de recetas para acceso offline
- **Navegación Intuitiva**: Bottom navigation con páginas principales

## 🧪 Testing

El proyecto incluye una suite completa de tests:

```bash
# Tests unitarios
flutter test

# Tests de integración
flutter test integration/

# Generar reporte de coverage
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

## 🚧 Consideraciones Técnicas y Limitaciones

### Decisiones de Arquitectura
- **Separación de Responsabilidades**: Cada feature es un módulo independiente
- **Inyección de Dependencias**: Uso de GetIt para facilitar testing y mantenimiento
- **Persistencia Local**: ObjectBox para mejor rendimiento en dispositivos móviles
- **Estado Reactivo**: BLoC pattern para gestión predecible del estado

### Limitaciones Actuales
- **API Externa**: Dependencia de TheMealDB para datos de recetas
- **Funcionalidad Offline**: Solo recetas favoritas disponibles sin conexión
- **Idiomas**: Interfaz en inglés (API limitation)

### Mejoras Futuras Identificadas
- [ ] **Modo Offline Completo**: Cache de todas las recetas vistas
- [ ] **Modo Oscuro**: Soporte completo para temas oscuros
- [ ] **Internacionalización**: Soporte multi-idioma
- [ ] **Persistencia de lista de ingredientes:** Guardar en objectBox

## 📊 Métricas del Proyecto

- **Versión Actual**: 0.6.1+20
- **Dependencias**: 20+ paquetes principales
- **Arquitectura**: Clean Architecture + BLoC Pattern

## 🤝 Contribución

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## 📄 Licencia

Este proyecto es privado y no está destinado para distribución pública.

