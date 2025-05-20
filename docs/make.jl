using PythonDictMacros
using Documenter

DocMeta.setdocmeta!(PythonDictMacros, :DocTestSetup, :(using PythonDictMacros); recursive=true)

makedocs(;
    modules=[PythonDictMacros],
    authors="Mark Kittisopikul <kittisopikulm@janelia.hhmi.org> and contributors",
    sitename="PythonDictMacros.jl",
    format=Documenter.HTML(;
        canonical="https://mkitti.github.io/PythonDictMacros.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/mkitti/PythonDictMacros.jl",
    devbranch="main",
)
