import com.android.build.gradle.AppExtension

val android = project.extensions.getByType(AppExtension::class.java)

android.apply {
    flavorDimensions("flavor-type")

    productFlavors {
        create("dev") {
            dimension = "flavor-type"
            applicationId = "com.thisisdoanh.datn.pictidy.dev"
            resValue(type = "string", name = "app_name", value = "Dev: PicTidy")
        }
        create("prod") {
            dimension = "flavor-type"
            applicationId = "com.thisisdoanh.datn.pictidy"
            resValue(type = "string", name = "app_name", value = "PicTidy")
        }
    }
}