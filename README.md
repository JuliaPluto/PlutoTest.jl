# PlutoTest.jl _(alpha release)_
_Visual, reactive testing library for Julia_

The PlutoTest.jl package provides a macro `@test` that you can use to verify your code's correctness. **But instead of just showing _"Pass"_ or _"Fail"_, it uses ✨ *time travel* ✨ to tell you _why_ your test failed.**

![Demo screencap](https://user-images.githubusercontent.com/6933510/116827035-60f4cf00-ab97-11eb-9dd9-631426e435af.gif)


# Install & use

First, update Pluto!

```julia
julia> import Pkg; Pkg.add(Pkg.PackageSpec(url="https://github.com/JuliaPluto/PlutoTest.jl"))

julia> using PlutoTest

julia> @test 1 + 1 == 2
```

This package is still an _alpha release_, don't use it to `@test is_safe(crazy_new_bike_design)`.

# Reactive

This testing library is designed to be used inside Pluto.jl, a **reactive** notebook. If you write your tests in the same notebook as your code, then Pluto will automatically re-run the affected tests after you make a change. Tests that are unaffected will not need to re-run. Neat!

### Navigation

When a test gets re-run and it fails outside of your viewport, you will be notified with a red dot on the edge of the screen. You can click on a dot to jump to the test, multiple dots indicate multiple tests.

![](https://user-images.githubusercontent.com/6933510/116827278-74ed0080-ab98-11eb-89be-f808429ed942.gif)

# Future: GitHub Action

In the future, it will be easy to run Pluto-based, PlutoTest-based tests automatically on GitHub Actions or Travis CI. In addition to running your tests, it will **upload a rendered notebook** as artifact to the test run. If a test failed, you can open the notebook and see why.
