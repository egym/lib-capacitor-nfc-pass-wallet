plugins {
    id("com.android.library") version "8.9.1"
    id("org.jetbrains.kotlin.android") version "2.1.10"
    id("maven-publish")
    signing
}

group = "com.egym.nfc"
version = "0.1.0"

android {
    namespace = "com.egym.nfcpasswallet"
    compileSdk = 35

    defaultConfig {
        minSdk = 24
    }

    publishing {
        singleVariant("release") {
            withSourcesJar()
            withJavadocJar()
        }
    }
}

kotlin {
    jvmToolchain(17)
}

dependencies {
    implementation("com.google.android.gms:play-services-pay:16.5.0")
    testImplementation("junit:junit:4.13.2")
    testImplementation("io.mockk:mockk:1.13.13")
}

tasks.withType<Test>().configureEach {
    useJUnit()
}

publishing {
    publications {
        create<MavenPublication>("release") {
            afterEvaluate {
                from(components["release"])
            }
            groupId = "com.egym.nfc"
            artifactId = "nfc-pass-wallet"
            version = project.version.toString()

            pom {
                name.set("EGYM NFC Pass Wallet Android SDK")
                description.set("Android SDK for EGYM wallet/NFC pass flows")
                url.set("https://github.com/egym/lib-capacitor-nfc-pass-wallet")
                licenses {
                    license {
                        name.set("Proprietary")
                        url.set("https://www.egym.com")
                    }
                }
                scm {
                    connection.set("scm:git:git://github.com/egym/lib-capacitor-nfc-pass-wallet.git")
                    developerConnection.set("scm:git:ssh://github.com:egym/lib-capacitor-nfc-pass-wallet.git")
                    url.set("https://github.com/egym/lib-capacitor-nfc-pass-wallet")
                }
            }
        }
    }

    repositories {
        maven {
            name = "mavenCentral"
            url = uri("https://central.sonatype.com/api/v1/publisher/upload")
            credentials {
                username = providers.environmentVariable("ORG_GRADLE_PROJECT_mavenCentralUsername").orNull
                password = providers.environmentVariable("ORG_GRADLE_PROJECT_mavenCentralPassword").orNull
            }
        }
    }
}

signing {
    useInMemoryPgpKeys(
        providers.environmentVariable("MAVEN_GPG_PRIVATE_KEY").orNull,
        providers.environmentVariable("MAVEN_GPG_PASSPHRASE").orNull,
    )
    sign(publishing.publications)
}
