import ProjectDescription

let tuist = Tuist(
    project: .tuist(
        generationOptions: .options(
            manifestEnvironment: [
                "DARWINPRIVATEFRAMEWORKS_*",
            ]
        )
    )
)
