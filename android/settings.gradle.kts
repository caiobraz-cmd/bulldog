// 1. GERENCIAMENTO DE PLUGINS
pluginManagement {
    // Lógica para encontrar o SDK (necessária aqui)
    val localPropertiesFile = File(settings.rootDir, "local.properties")
    val properties = java.util.Properties()
    if (localPropertiesFile.exists()) {
        properties.load(localPropertiesFile.reader(Charsets.UTF_8))
    }
    val flutterSdkPath = properties.getProperty("flutter.sdk")
    require(flutterSdkPath != null) { "flutter.sdk not set in local.properties" }

    // Inclui o build do plugin do Flutter
    includeBuild(File(flutterSdkPath, "packages/flutter_tools/gradle"))

    // Repositórios para os *plugins*
    repositories {
        gradlePluginPortal()
        google()
        mavenCentral()
    }

    // 2. DEFINIÇÃO DAS VERSÕES DOS PLUGINS (para corrigir os Warnings)
plugins {
    id("dev.flutter.flutter-gradle-plugin") version "1.0.0" apply false
    id("com.android.application") version "8.6.0" apply false // VERSÃO ATUALIZADA
    id("org.jetbrains.kotlin.android") version "2.1.0" apply false // VERSÃO ATUALIZADA
    }
}

// 3. INCLUIR O MÓDULO :app
include(":app")
rootProject.name = "bulldogs" // O nome do seu projeto

// 4. GERENCIAMENTO DE DEPENDÊNCIAS
dependencyResolutionManagement {
    // Lógica para encontrar o SDK (duplicada, necessário pelo Gradle)
    val localPropertiesFile = File(settings.rootDir, "local.properties")
    val properties = java.util.Properties()
    if (localPropertiesFile.exists()) {
        properties.load(localPropertiesFile.reader(Charsets.UTF_8))
    }
    val flutterSdkPath = properties.getProperty("flutter.sdk")
    require(flutterSdkPath != null) { "flutter.sdk not set in local.properties" }

   
    repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)

    // Repositórios para as *dependências*
    repositories {
        google()
        mavenCentral()
        // A LINHA QUE FALTAVA: informa onde achar o io.flutter:x86_64_debug
        maven(url = File(flutterSdkPath, "bin/cache/artifacts/engine/android-artifacts/").toURI().toString())
    }
}