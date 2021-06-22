# PlutoTest.jl _(alpha release)_

> _Visual, reactive testing library for Julia_

A macro `@test` that you can use to verify your code's correctness. **But instead of just saying _"Pass"_ or _"Fail"_, let's try to show you _why_ a test failed.**
-   ✨ _time travel_ ✨ to replay the execution step-by-step
-   ⭐️ _multimedia display_ ⭐️ to make results easy to read

---

![Demo screencap](https://user-images.githubusercontent.com/6933510/116827035-60f4cf00-ab97-11eb-9dd9-631426e435af.gif)

[Try this demo in your browser](https://juliapluto.github.io/PlutoTest.jl/src/notebook.html)

# Install & use

First, update Pluto to at least `0.14.5`! Next, add this package like so: _(you can skip this step in Pluto 0.15 and above)_

```julia
julia> begin
           import Pkg
           Pkg.activate(mktempdir())
           Pkg.add([
               Pkg.PackageSpec(name="PlutoTest")
           ])
       end
```

Inside your notebook, use the `@test` macro to test whether something returns `true`:

```julia
julia> using PlutoTest

julia> @test 1 + 1 == 2
```

This package is still an _alpha release_, don't use it to `@test is_safe(crazy_new_bike_design)`.

# Reactive

This testing library is designed to be used inside Pluto.jl, a **reactive** notebook. If you write your tests in the same notebook as your code, then Pluto will automatically re-run the affected tests after you make a change. Tests that are unaffected will not need to re-run. Neat!

### Navigation

When a test gets re-run and it fails outside of your viewport, you will be notified with a red dot on the edge of the screen. You can click on a dot to jump to the test, multiple dots indicate multiple tests.

![](https://user-images.githubusercontent.com/6933510/116827278-74ed0080-ab98-11eb-89be-f808429ed942.gif)

_(Only enabled on Chrome and Firefox for now.)_

# Future: GitHub Action

In the future, it will be easy to run Pluto-based, PlutoTest-based tests automatically on GitHub Actions or Travis CI. In addition to running your tests, it will **upload a rendered notebook** as artifact to the test run ([sample](https://juliapluto.github.io/PlutoTest.jl/src/notebook.html)). If a test failed, you can open the notebook and see why.

# How does it work?

Take a look at the [source code](https://juliapluto.github.io/PlutoTest.jl/src/notebook.html)! (It's a Pluto notebook 🌝)
