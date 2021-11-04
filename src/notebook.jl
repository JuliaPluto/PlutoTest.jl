### A Pluto.jl notebook ###
# v0.16.4

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

# ╔═╡ ab02837b-79ec-40d7-bff1-c1d2dd7362ef
md"""
# PlutoTest.jl
_Visual, reactive testing library for Julia_

A macro `@test` that you can use to verify your code's correctness. 

**But instead of just saying _"Pass"_ or _"Fail"_, let's try to show you _why_ a test failed.**
- ✨ _time travel_ ✨ to replay the execution step-by-step
- ⭐️ _multimedia display_ ⭐️ to make results easy to read
"""

# ╔═╡ 56347b7e-5007-45f8-8f6d-8ac8cc719637
md"""
Tests have _time-travel_ functionality built in! **Click on the test results above.**
"""

# ╔═╡ fd8428a3-9fa3-471a-8b2d-5bbb8fdb3137
is_good_boy(x) = true;

# ╔═╡ 191f1f04-18d4-485b-af8b-a2f073b7043b
md"""
## Installation and more info

> [github.com/JuliaPluto/PlutoTest.jl](https://github.com/JuliaPluto/PlutoTest.jl)
"""

# ╔═╡ ec1fd70a-d92a-4688-98b2-135879f07141
md"""
### (You need `Pluto ≥ 0.14.5` to run this notebook)
"""

# ╔═╡ 9d49ea50-8158-4d8b-97af-edba1f7dc38b
x = [1,3]

# ╔═╡ 1aa24b1c-e8ca-4de7-b614-7a3f02b4833d
# Fons wtf
always_false(args...; kwargs...) = true

# ╔═╡ b0ab9327-8240-4d34-bdd9-3f8f5117bb29
struct PlutoStylesheet
	code
end

# ╔═╡ 1e619ca9-e00f-46d0-b327-85b33929787f
function Base.show(io::IO, mime::MIME"text/html", stylesheet::PlutoStylesheet)
	# show(io, mime, md"`<style>...`")
	print(io, "Stylesheet")
end

# ╔═╡ 8a2e8348-49cf-4855-b5b3-cdee33e5ed67
# const pluto_test_css = PlutoStylesheet("""
pluto_test_css = PlutoStylesheet("""
pt-dot {
	flex: 0 0 auto;
	background: grey;
	width: 1em;
	height: 1em;
	bottom: -.1em;
	border-radius: 100%;
	margin-right: .7em;
	display: block;
	position: relative;
	cursor: pointer;
}

pt-dot.floating {
	position: fixed;
	z-index: 60;
	visibility: hidden;
	transition: transform linear 240ms;
	opacity: .8;
}
.show-top-float > pt-dot.floating.top,
.show-bottom-float > pt-dot.floating.bottom {
	visibility: visible;
}

pt-dot.floating.top {
	top: 5px;
}
pt-dot.floating.bottom {
	bottom: 5px;
}


.fail > pt-dot {
	background: #f75d5d;

}
.pass > pt-dot {
	background: #56a038;
}

@keyframes fadeout {
    0% { opacity: 1;}
    100% { opacity: 0; pointer-events: none;}
}


.pass > pt-dot.floating {

    animation: fadeout 2s;

	animation-fill-mode: both;
	animation-delay: 2s;

	/*opacity: 0.4;*/
	
}


.pluto-test {
	font-family: "JuliaMono", monospace;
	font-size: 0.75rem;
	white-space: normal;
	padding: 4px;
	
	min-height: 25px;
}


.pluto-test.pass {
	color: rgba(0,0,0,.5);
}

.pluto-test.fail {
background: linear-gradient(90deg, #ff2e2e14, transparent);
border-radius: 7px;
}


.pluto-test>.arg_result {
	flex: 0 0 auto;
}

.pluto-test>.arg_result>div,
.pluto-test>.arg_result>div>pluto-display>div {
	display: inline-flex;
}


.pluto-test>.comma {
	margin-right: .5em;
}

.pluto-test.call>code {
	padding: 0px;
}

.pluto-test.call.infix-operator>div {
	overflow-x: auto;
}

.pluto-test {
	display: flex;
	align-items: baseline;
}

.pluto-test.call.infix-operator>.fname {
	margin: 0px .6em;
	/*color: darkred;*/
}


/* expanding */


.pluto-test:not(.expanded) {
	cursor: pointer;
}

.pluto-test:not(.expanded) > p-frame-viewer > p-frame-controls {
	display: none;
	
}

.pluto-test.expanded > p-frame-viewer {
    max-width: 100%;
}
.pluto-test.expanded > p-frame-viewer > p-frames > slotted-code > line-like {
	flex-wrap: wrap;
}
.pluto-test.expanded > p-frame-viewer > p-frames > slotted-code > line-like > pluto-display[mime="application/vnd.pluto.tree+object"] {
	/*flex-basis: 100%;*/
}
""")

# ╔═╡ 42671258-07a0-4015-8f47-4b3032595f08
# const frames_css = PlutoStylesheet("""
frames_css = PlutoStylesheet("""
p-frame-viewer {
	display: inline-flex;
	flex-direction: column;
}
p-frames,
p-frame-controls {
	display: inline-flex;
}
""")

# ╔═╡ 0d70962a-3880-4dee-a439-35068d019f5a
md"""
# Type definitions
"""

# ╔═╡ 113cc425-e224-4f77-bfbd-ef4eb1d1ed70
abstract type TestResult end

# ╔═╡ 6188f559-bcab-4da6-84b2-a3fe522a5c3c
abstract type Fail <: TestResult end

# ╔═╡ c24b46ce-bcbb-4dc9-8a59-b5b1bd2cd617
abstract type Pass <: TestResult end

# ╔═╡ 5041085e-a406-4ed4-ab82-84d8f126cf0f
const Code = Any

# ╔═╡ 8c92bad9-234e-47dd-a599-b75dc6d5db89
# struct Correct <: Pass
# 	expr::Code
# end

# ╔═╡ 03ccd498-83c3-41bb-84d7-625adabd7aee
struct CorrectCall <: Pass
	expr::Code
	steps::Vector
end

# ╔═╡ 1bcf8bd1-c8a3-49a1-9791-d813aa856399
Base.@kwdef struct ErrorCall <: Fail
	expr::Code
	steps::Vector
	error
end

# ╔═╡ 656c4190-b49e-4225-869d-eeb7e8e41e72
# struct Wrong <: Fail
# 	expr::Code
# 	step
# end

# ╔═╡ 14c525a1-eca1-466b-8e63-3a90d7d7111c
struct WrongCall <: Fail
	expr::Code
	steps::Vector
end

# ╔═╡ a2efc968-246c-40c2-b285-2ec94b185a44
md"""
# Test macro
"""

# ╔═╡ bfe4dc61-9160-4c7e-8897-9c723b309adc
# function test(expr)
# 	if Meta.isexpr(expr, :call, 3) && expr.args[1] === :(==)
# 	quote
# 		expr_raw = $(QuoteNode(expr))
# 		try
# 			left = $(expr.args[2] |> esc)
# 			right = $(expr.args[3] |> esc)
			
# 			result = left == right
			
# 			if result === true
# 				Correct(expr_raw)
# 			elseif result === false
# 				WrongEquality(expr_raw, left, right)
# 			else
# 				Wrong(expr_raw, result)
# 			end
# 		catch e
# 			rethrow(e)
# 			# Error(expr_raw, e)
# 		end
# 	end
# 	end
# end

# ╔═╡ dbfbcc16-c740-436c-bbf0-fee16b0a20c5
md"""
# $(html"<img src='https://cdn.jsdelivr.net/gh/ionic-team/ionicons@5.5.1/src/svg/time-outline.svg' style='height: .75em; margin-bottom: -.1em'>") _Time travel_ evaluation

In Julia, expressions are objects! This means that, before evaluation, code is expressed as a Julia object:
"""

# ╔═╡ 7c2bab29-8609-4575-b2ca-7feb34915645
md"""
You can use `Core.eval` to evaluate expressions at runtime:
"""

# ╔═╡ 838b5904-1de2-4d9f-8f3c-a93ec224d40e
md"""
But _did you know_ that you can also **partially evaluate** expressions? 
"""

# ╔═╡ b056a99d-5b13-47ba-a199-d788410e3c99
md"""
Here, `ex2` is not a raw `Expr` — it _contains_ an evaluated array!
"""

# ╔═╡ 5b093e83-78c1-4187-b406-56e79800e1be
md"""
### `Computed` struct

Our time travel mechanism will be based on the partial evaluation principle introduced above. To differentiate between computed results and the original expression, we will wrap all computed results in a `struct`.
"""

# ╔═╡ a461f1fd-b5a5-4ae3-a47c-067a6081fb24
struct Computed
	x
end

# ╔═╡ f9c81ab1-556c-4d81-bee8-2897c20e324d
md"""
We also add a function to recursively _unwrap_ an expression with `Computed` entries:
"""

# ╔═╡ a392d2d6-5a16-4383-b0ef-5003aa2de9fa
unwrap_computed(x) = x

# ╔═╡ ae95b691-f54b-4bf5-b17b-3e5bd1edf75e
unwrap_computed(c::Computed) = c.x

# ╔═╡ 12119016-fa61-4d38-8c58-821ea435df7d
unwrap_computed(e::Expr) = Expr(e.head, unwrap_computed.(e.args)...)

# ╔═╡ 2c1b906d-71b9-430e-83ed-d4c8c0018632
md"""
## Stepping function


"""

# ╔═╡ b46b02b7-242a-48bf-bac8-8a3b6474384b
function lonely_function end

# ╔═╡ 7db64b02-8f64-4146-bf77-ef94cb45aae0
function increase_counter(x, ref)
	ref[] = ref[] + 1
	return x
end

# ╔═╡ 886c8080-cd29-4c72-898b-4fbd3a988e4d


# ╔═╡ ec6f1b07-d026-45ca-996d-be7693664cd7
deepcopy_expr(e::Expr) = Expr(e.head, (deepcopy_expr(sub_e) for sub_e in e.args)...)

# ╔═╡ dadf1c50-6588-4345-a240-69a72336c7cd
deepcopy_expr(e) = e

# ╔═╡ c335fea6-6bf5-489f-9218-de67e45c38a8
let
	x = :(let 
		x = 3 - sqrt(16)
		false
	end)
	x.args[2].args[2]
end

# ╔═╡ a29d5277-e97a-4cca-8e31-8037f9cfdd80
"""
    build_check_for_computed(lens::Expr, default::Expr)

Ideally, this function doesn't exist.

It will wrap a normal expression into an expression that first checks if the `lens` refers to a `Computed` value, if so use the value it contains, if not, use the original expression.

This is fine for now, but it isn't beautiful, and I didn't want to make this output even bigger expressions (as these are put inline into existing expressions, making them already quite unreadable), so there isn't any error handling. (If executing `lens` gives an error, you're out).

Ideally we don't have to check for `Computed`, because we know very well which references will be `Computed` and which won't. But that's for later 🙃
"""
function build_check_for_computed(lens::Expr, default::Expr)
	if Meta.isexpr(default, :..., 1) && Meta.isexpr(default.args[1], :call)
		# Can't have `x...` as a standalone expression, so need to 
		# dive in to replace the `x` instead of the whole thing
		# e.g. `(x[1] isa Computed ? x[1].x : (1:7))...` (fine)
		# instead of `(x isa Computed ? x.x : (1:7)...)` (not fine)
		# Subtle, but important difference.
		:((
			$(lens).args[1] isa Computed ?
			$(lens).args[1].x :
			$(esc(default.args[1]))
		)...)
	elseif Meta.isexpr(default, :call)
		# We can assume that a `call` will be done before
		:($(lens) isa Computed ? $(lens).x : $(esc(default)))
	else
		esc(default)
	end

end

# ╔═╡ 4f7aac13-9e49-4b2b-8d78-53f583f6130a
function build_check_for_computed(lens::Expr, default::Any)
	esc(default)
end

# ╔═╡ 74929fa6-d1f7-41cd-ab55-48f35d5fbf28
md"""
## code\_loweredish\_with\_lenses
"""

# ╔═╡ 5e66e59b-fdb8-4373-b231-097b0227dc5c
begin
	struct ExprWithLens
		expr
		lens
		expr_to_show
	end
	ExprWithLens(; expr, lens=[], expr_to_show=expr) = ExprWithLens(expr, lens, expr_to_show)
end

# ╔═╡ 17dea9e5-84ea-4476-a318-cc475043c83b
Frames = Vector{ExprWithLens}

# ╔═╡ 779c75cf-b35d-439c-87b7-b42740d2c870
begin
    (var"#49881#pluto_result", var"#49882#julia_test_result") = try
            var"#49889#result" = begin
                    local var"#49883#expr_raw" = $(QuoteNode(:(x = 3 - sqrt(16))))
                    try
                        var"#49884#steps" = begin
                                begin
                                    var"#49885#expr" = $(QuoteNode(:(x = 3 - sqrt(16))))
                                    var"#49886###steps#4270" = Any[var"#49885#expr"]
                                    var"#49887###expr_ref#4269" = Main.var"workspace#155".Ref{Main.workspace#155.Any}(var"#49885#expr")
                                    begin
                                        nothing
                                        nothing
                                        var"#49888#val" = try
                                                sqrt(16)
                                            catch var"#49904#e"
                                                #= /home/michiel/PlutoTest.jl/src/notebook.jl#==#f5d9a4c5-300f-4dae-8507-346ec0b74632:53 =# @error ":((\$(Expr(:escape, :sqrt)))(\$(Expr(:escape, 16))))"
                                                Main.workspace#155.rethrow(var"#49904#e")
                                            end
                                        var"#49887###expr_ref#4269"[] = (Main.workspace#2.deepcopy_expr)(var"#49887###expr_ref#4269"[])
                                        ((var"#49887###expr_ref#4269"[]).args[2]).args[3] = Main.workspace#155.Computed(var"#49888#val")
                                        Main.workspace#155.push!(var"#49886###steps#4270", var"#49887###expr_ref#4269"[])
                                    end
                                    begin
                                        nothing
                                        nothing
                                        var"#49888#val" = try
                                                3 - if ((var"#49887###expr_ref#4269"[]).args[2]).args[3] isa Main.workspace#155.Computed
                                                        (((var"#49887###expr_ref#4269"[]).args[2]).args[3]).x
                                                    else
                                                        sqrt(16)
                                                    end
                                            catch var"#49904#e"
                                                #= /home/michiel/PlutoTest.jl/src/notebook.jl#==#f5d9a4c5-300f-4dae-8507-346ec0b74632:53 =# @error ":((\$(Expr(:escape, :-)))(\$(Expr(:escape, 3)), if ((var\"##expr_ref#4269\"[]).args[2]).args[3] isa Computed\n          (((var\"##expr_ref#4269\"[]).args[2]).args[3]).x\n      else\n          \$(Expr(:escape, :(sqrt(16))))\n      end))"
                                                Main.workspace#155.rethrow(var"#49904#e")
                                            end
                                        var"#49887###expr_ref#4269"[] = (Main.workspace#2.deepcopy_expr)(var"#49887###expr_ref#4269"[])
                                        (var"#49887###expr_ref#4269"[]).args[2] = Main.workspace#155.Computed(var"#49888#val")
                                        Main.workspace#155.push!(var"#49886###steps#4270", var"#49887###expr_ref#4269"[])
                                    end
                                    begin
                                        nothing
                                        nothing
                                        var"#49888#val" = try
                                                3 - if ((var"#49887###expr_ref#4269"[]).args[2]).args[3] isa Main.workspace#155.Computed
                                                        (((var"#49887###expr_ref#4269"[]).args[2]).args[3]).x
                                                    else
                                                        sqrt(16)
                                                    end
                                            catch var"#49904#e"
                                                #= /home/michiel/PlutoTest.jl/src/notebook.jl#==#f5d9a4c5-300f-4dae-8507-346ec0b74632:53 =# @error ":((\$(Expr(:escape, :-)))(\$(Expr(:escape, 3)), if ((var\"##expr_ref#4269\"[]).args[2]).args[3] isa Computed\n          (((var\"##expr_ref#4269\"[]).args[2]).args[3]).x\n      else\n          \$(Expr(:escape, :(sqrt(16))))\n      end))"
                                                Main.workspace#155.rethrow(var"#49904#e")
                                            end
                                        var"#49887###expr_ref#4269"[] = (Main.workspace#2.deepcopy_expr)(var"#49887###expr_ref#4269"[])
                                        (var"#49887###expr_ref#4269"[]).args[2] = Main.workspace#155.Computed(var"#49888#val")
                                        Main.workspace#155.push!(var"#49886###steps#4270", var"#49887###expr_ref#4269"[])
                                    end
                                    var"#49886###steps#4270"
                                end
                            end
                        var"#49889#result" = Main.workspace#155.unwrap_computed(Main.workspace#155.last(var"#49884#steps"))
                        if var"#49889#result" === true
                            Main.workspace#155.CorrectCall(var"#49883#expr_raw", var"#49884#steps")
                        else
                            Main.workspace#155.WrongCall(var"#49883#expr_raw", var"#49884#steps")
                        end
                    catch var"#49904#e"
                        #= /home/michiel/PlutoTest.jl/src/notebook.jl#==#b6e8a170-12cc-4d97-905d-274e2609bfd8:20 =# @info "e" e
                        Main.workspace#155.rethrow(var"#49904#e")
                    end
                end
            (var"#49889#result", (Main.workspace#155.Test).Returned(var"#49889#result" isa Main.workspace#155.CorrectCall, "", $(QuoteNode(:(#= /home/michiel/PlutoTest.jl/src/notebook.jl#==#40902263-04b9-4022-b156-a19bdb0b568c:1 =#)))))
        catch var"#49897#err"
            Main.workspace#155.rethrow(var"#49897#err")
            (var"#49897#err", (Main.workspace#155.Test).Threw(var"#49897#err", (Main.workspace#155.Base).catch_stack(), $(QuoteNode(:(#= /home/michiel/PlutoTest.jl/src/notebook.jl#==#40902263-04b9-4022-b156-a19bdb0b568c:1 =#)))))
        end
    try
        (Main.workspace#155.Test).do_test(var"#49882#julia_test_result", $(QuoteNode(:(x = 3 - sqrt(16)))))
    end
    var"#49881#pluto_result"
end

# ╔═╡ 67ad5781-e8bd-4f13-a03e-dcc5773574a0
@info "hi"

# ╔═╡ c2e3377d-a456-40a1-b904-d285d47b50c6
PlutoRunner.computers

# ╔═╡ 37e2d966-0f46-4b64-bb3a-c057e344fa02
eee = :(x = 3 - sqrt(16))

# ╔═╡ bcff728d-0781-44ce-8033-9f642207a475
eee.args[2].args[3]

# ╔═╡ 0a3f5c6c-6e1b-458c-bf91-523a0b639b41
md"""
#### `code_loweredish_with_lenses` for all non-Expr types
"""

# ╔═╡ 43fe89d7-f33e-4dfa-853e-327e981feb1e
function code_loweredish_with_lenses(x::Symbol)
	# Should we replace variables with their value as a step?
	[ExprWithLens(expr=x, lens=[])]
	# For now I'm assuming people know what their variables are...
	# return ExprWithLens[]
end

# ╔═╡ fc000550-3053-483e-bc41-6aed22c3999c
code_loweredish_with_lenses(x::QuoteNode) = ExprWithLens[]

# ╔═╡ 3f11ca4c-dd06-47c9-92e2-cb97c18a06db
code_loweredish_with_lenses(x::Number) = ExprWithLens[]

# ╔═╡ b155d336-f746-4c82-8206-ab1a49cedea8
code_loweredish_with_lenses(x::String) = ExprWithLens[]

# ╔═╡ 221aa13b-aa25-4145-8076-da77432364bb
code_loweredish_with_lenses(x::LineNumberNode) = ExprWithLens[]

# ╔═╡ 2a514f2f-79c8-4b0d-be8a-170f3386d5d5
code_loweredish_with_lenses(x) = error("Type of expression not supported ($(typeof(x)))")
# code_loweredish_with-lenses(x) = [ExprWithLens(expr=x, lens=[])]

# ╔═╡ 9fb4d52d-77f2-4032-a769-6d5e60be43bf
md"""
#### `expr_lenses_for_quoted`
Which will ignore everything except `:$` expressions, and then call `code_loweredish_with_lenses` for those.
"""

# ╔═╡ cade56ad-312e-40cf-bcda-11480ce27852
expr_lenses_for_quoted(x, _) = ExprWithLens[]

# ╔═╡ d384e3fc-b207-48ce-bc7b-1b47a14b1581
function apply_lens_to_frames(lens, frames)
	map(frames) do frame
		ExprWithLens(
			expr=frame.expr,
			lens=[lens..., frame.lens...]
		)
	end
end

# ╔═╡ a6e8c835-f209-445a-9f43-cdf2ecfd1b57
md"""
## Tests for all expression types
"""

# ╔═╡ 5759b2cc-1e96-4069-ae42-bc159c7cf5fb
md"#### Basic"

# ╔═╡ 716d9ddc-18dc-4973-924e-e5ebf9161ff6
md"#### Edge cases"

# ╔═╡ de94f2b5-96ae-4936-870f-7639a39fd40d
md"""
Functions that aren't just coming from simple references (so say, Higher-order functions and such) should actually get a mention in the time travel. Right now it is still as this odd "#X#123" thingy (which is even worse when it is anonymous..), but this we could make prettier later.
"""

# ╔═╡ 21d4560e-721f-4ed4-9db7-86a8151ab22c
md"""
## Displaying objects inside code
"""

# ╔═╡ 99afc7f4-727c-4277-8311-f2ffa94830ae
md"""
#### Slotting

We walk through the expression tree. Whenever we find a `Computed` object, we generate a random key (e.g. `iosjddfo`), we add it to our dictionary (`found`). In the expression, we replace the `Computed` object with a placeholder symbol `__slotiosjddfo__`. We will later be able to match the object to this slot.
"""

# ╔═╡ 4956526a-daf9-43c9-bff3-ff2446016e2e
slot!(found, c::Computed) = let
	k = Symbol("__slot", join(rand('a':'z', 16)), "__")
	found[k] = c
	k
end

# ╔═╡ 84ff6a23-c134-4910-b630-a7ad45f3bf29
slot!(found, x) = x

# ╔═╡ 318363d0-6d9e-4144-b478-b775f437edaf
slot!(found, e::Expr) = Expr(e.head, slot!.([found], e.args)...)

# ╔═╡ 67fd07b7-340b-4e24-bc06-e4c85b186872
slot(e) = let
	d = Dict{Symbol,Any}()
	new_e = slot!(d, e)
	d, new_e
end

# ╔═╡ c6d5597c-d505-4125-88c4-10415934d2a4
md"""
### SlottedDisplay

We use `print` to turn the expression into source code.

For each line, we regex-search for slot variables, and we split the line around those. The code segments around slots are rendered inside `<pre-ish>` tags (like `<pre>` but inline), and the slots are replaced by [embedded displays](https://github.com/fonsp/Pluto.jl/pull/1126) of the objects.
"""

# ╔═╡ c877c109-db16-468c-8f3c-8294db859d6d
begin
	struct SlottedDisplay
		d
		e
	end
	SlottedDisplay(expr) = SlottedDisplay(slot(expr)...)
end

# ╔═╡ 8480d0d7-bdf7-468d-9344-5b789e33921c
# const slotted_code_css = PlutoStylesheet("""
slotted_code_css = PlutoStylesheet("""
slotted-code {
	font-family: "JuliaMono", monospace;
	font-size: .75rem;
	display: flex;
	flex-direction: column;
}
pre-ish {
	white-space: pre;
}

line-like {
	display: flex;
	align-items: baseline;
}
""")

# ╔═╡ b5763c10-e11c-4389-b6fc-421d2c9682f1
md"""
### Frame viewer

A widget that takes a series of elements and displays them as 'video frames' with a timeline scrubber.
"""

# ╔═╡ 3d5abd58-02ab-4b91-a7a3-d9068d4df017
md"""
## @visual_debug (awesome)
"""

# ╔═╡ 34f613a3-85fb-45a8-be3b-cd8e6b3cb5a2


# ╔═╡ f9ed2487-a7f6-4ce9-b673-f8a298cd5fc3
md"""
# Appendix
"""

# ╔═╡ 20166ec9-7084-4d58-8b19-3aa51cc8f2c6
md"""
## Macro Lenses

I need stuff like Accessors.jl, but I didn't feel like another dependency and also *felt* like I should be macro-ish. So that's that this is...
"""

# ╔═╡ 1633fe05-cb51-4032-b6b6-f23db72bbd49
struct FieldLens property::Symbol end

# ╔═╡ 7c312943-c48b-40e7-a499-227f7ff8aa59
struct PropertyLens property end

# ╔═╡ a0207e25-0398-4104-8c0f-a8fbd9fe1d53
struct EmptyPropertyLens end

# ╔═╡ 7d14b79c-74e5-4986-80b7-de7cd7d48670
quote2(x::Symbol) = QuoteNode(x)

# ╔═╡ 5950488e-2008-48d8-9095-7f9421df191e
quote2(x) = x

# ╔═╡ 77cc33a3-c2bc-4f2d-ba88-e3693ec79b0c
function lens_to_setter(subject, lens::Vector, value)
	if length(lens) === 0
		throw(ArgumentError("lens needs at least one element in path"))
	elseif length(lens) === 1
		property = lens[1]
		if property isa FieldLens
			:($subject.$(property.property) = $value)
		elseif property isa PropertyLens
			:($subject[$(quote2(property.property))] = $value)
		elseif property isa EmptyPropertyLens
			:($subject[] = $value)
		else
			error("Unknown lens type")
		end
	else
		property, path... = lens
		next_subject = if property isa FieldLens
			:($subject.$(property.property))
		elseif property isa PropertyLens
			:($subject[$(quote2(property.property))])
		elseif property isa EmptyPropertyLens
			:($subject[])
		else
			error("Unknown lens type")
		end

		lens_to_setter(next_subject, path, value)
	end
end

# ╔═╡ 5a3a0f63-dcce-49c9-84fd-a6317184820f
function lens_to_getter(subject, lens::Vector)
	if length(lens) == 0
		return subject
	end
	
	property, path... = lens
	next_subject = if property isa FieldLens
		:($subject.$(property.property))
	elseif property isa PropertyLens
		:($subject[$(quote2(property.property))])
	elseif property isa EmptyPropertyLens
		:($subject[])
	else
		error("Unknown lens type")
	end

	lens_to_getter(next_subject, path)
end

# ╔═╡ f5d9a4c5-300f-4dae-8507-346ec0b74632
"""
    function build_step_by_step_blocks(lowered::Vector{ExprWithLens};
      expr_ref_lens,
      steps_lens,
     )::Vector{Expr}

Transforms an `ExprWithLens`-list (created by `code_loweredish_with_lenses`), into a list of expressions that will mutate whatever `expr_ref_lens` points to.

- `expr_ref_lens` needs to point to a `Ref{Expr}`
- `steps_lens` needs to point to a `Vector{Expr}`
"""
function build_step_by_step_blocks(
	lowered::Vector{ExprWithLens};
	expr_ref_lens=:EXPR_REF_LENS_DEFAULT,
	steps_lens=:STEPS_LENS_DEFAULT,
)::Vector{Expr}
	map(lowered) do frame
		# This whoooooole thing is to not execute parts of the code multiple times.
		# It replaces, when possible, the arguments in the expression with a reference
		# to the argument in the latest version of the expression
		# (where some nodes are Computed, which we will use)
		frame_lens = lens_to_getter(expr_ref_lens, [
			EmptyPropertyLens(),
			frame.lens...,
		])
		# TODO Use the same check here as we use in `code_loweredish_with_lenses`..
		# .... Right now it only de-dupes inside calls, but not inside blocks
		# .... (which we do split up in code_loweredish_with_lenses)
		expr_with_arguments_as_references = if Meta.isexpr(frame.expr, :call) 
			Expr(
				frame.expr.head,
				map(enumerate(frame.expr.args)) do (i, arg)
					arg_lens = :($(frame_lens).args[$(i)])
					build_check_for_computed(arg_lens, arg)
				end...
			)
		else
			esc(frame.expr)
		end
		
		# If you feel like "I don't need that optimised shit",
		# and want to see an easier to digest result, uncomment this line
		#expr_with_arguments_as_references = esc(frame.expr)

		
		quote
			$(expr_ref_lens == :EXPR_REF_LENS_DEFAULT ? :(error("expr_ref_lens wasn't assigned, so this code will not work, but you can see and inspect it")) : nothing)
			$(steps_lens == :STEPS_LENS_DEFAULT ? :(error("steps_lens wasn't assigned, so this code will not work, but you can see and inspect it")) : nothing)

			val =try
				$(expr_with_arguments_as_references)
			catch e
				@error $(repr(expr_with_arguments_as_references))
				rethrow(e)
			end
			
			# Could use Accessors.jl to make this a lot less expensive... 🤷‍♀️
			$expr_ref_lens[] = $(deepcopy_expr)($expr_ref_lens[])
			$(lens_to_setter(
				expr_ref_lens,
				[EmptyPropertyLens(), frame.lens...],
				:(Computed(val))
			))
			# TODO Ideally we even render the step here directly,
			# .... so any side-effects will show up in time-travel.
			push!($steps_lens, $expr_ref_lens[])
		end
	end
end

# ╔═╡ 35f63c4e-3583-4ea8-a057-31f18f8a09d6
md"""
## DisplayOnly
"""

# ╔═╡ ef59d0f0-0f02-4089-a49d-53fb0427c3a0
embed_display(x) = if isdefined(Main, :PlutoRunner) && isdefined(Main.PlutoRunner, :embed_display)
	# if this package is used inside Pluto, and Pluto is new enough
	Main.PlutoRunner.embed_display(x)
else
	identity(x)
end

# ╔═╡ 35b2770e-1db6-4327-bf86-c27a4b61dbd3
function is_inside_pluto(m::Module)::Bool
	if isdefined(m, :PlutoForceDisplay)
		return m.PlutoForceDisplay
	else
		isdefined(m, :PlutoRunner) && parentmodule(m) === Main
	end
end

# ╔═╡ 2f6e353d-2cdc-46d6-9727-01b0a6167ca0
ERROR_ON_UNKNOWN_EXPRESSION_TYPE = is_inside_pluto(@__MODULE__)

# ╔═╡ 22640a2f-ea38-4517-a4f3-7a65e60ffebe
"""
	@displayonly expression

Marks a expression as Pluto-only, which means that it won't be executed when running outside Pluto. Do not use this for your own projects.
"""
macro skip_as_script(ex) is_inside_pluto(__module__) ? esc(ex) : nothing end

# ╔═╡ cf314b21-3f4f-4637-b1ce-ec1d5d5af966
begin
	@skip_as_script begin
		import Pkg
		Pkg.activate("..")
		Pkg.instantiate()
	end
	import HypertextLiteral: @htl

	import Test: Test, @test_warn, @test_nowarn, @test_logs, @test_skip, @test_broken, @test_throws, @test_deprecated
	
	export @test_nowarn, @test_warn, @test_logs, @test_skip, @test_broken, @test_throws, @test_deprecated
end

# ╔═╡ 872b4877-30dd-4a92-a3c8-69eb50675dcb
preish(x) = @htl("<pre-ish>$(x)</pre-ish>")

# ╔═╡ e968fc57-d850-4e2d-9410-8777d03b7b3c
function frames(fs::Vector)
	l = length(fs)
	
	startframe = l > 2 ? l - 1 : l
	
	@htl("""
		<p-frame-viewer>
		<p-frames>
		$(fs)
		</p-frames>
		
		<p-frame-controls>
		<img src="https://cdn.jsdelivr.net/gh/ionic-team/ionicons@5.5.1/src/svg/time-outline.svg" style="width: 1em; height: 1em; transform: scale(-1,1); opacity: .5; margin-left: 2em;">
		<input class="timescrub" style="filter: hue-rotate(149deg) grayscale(.9);" type=range min=1 max=$(l) value=$(startframe)>
		</p-frame-controls>
		
		
		<script>
		const div = currentScript.parentElement
		
		const input = div.querySelector("p-frame-controls > input.timescrub")
		const frames = div.querySelector("p-frames")
		
		const setviz = () => {
			Array.from(frames.children).forEach((f,i) => {
				f.style.display = i + 1 === input.valueAsNumber ? "inherit" : "none"
			})
		}
		
		setviz()
		
		input.addEventListener("input", setviz)

		</script>



		</p-frame-viewer>
		
		<style>
		$(frames_css)
		</style>
		""")
	
	
	
end

# ╔═╡ b273d3d3-648f-4d34-94e7-e49277d4ba29
with_slotted_css(x) = @htl("""
	$(x)
	<style>
	$(slotted_code_css)
	</style>
	""")

# ╔═╡ d97987a0-bdc0-46ed-a6a5-f35c1ce961dc
ex1 = @skip_as_script :(first([56,sqrt(9)]))

# ╔═╡ 69bfb438-7ecf-4f9b-8bc4-51e07aa46ef1
@skip_as_script Core.eval(Module(), ex1)

# ╔═╡ a3c41025-2f4a-4f9c-8577-72e4b7abbb98
ex2_inner = @skip_as_script ex1.args[2]

# ╔═╡ 3e79ff61-6532-4879-9402-86473aa7d960
ex2_inner_result = @skip_as_script Core.eval(Module(), ex2_inner)

# ╔═╡ 38e54516-cdf4-4c1d-815b-68e1e7a7f6f7
ex3 = Expr(:call, :first, Computed(ex2_inner_result))

# ╔═╡ 9bed78b6-5a8f-44ce-ab66-cab685daf264
unwrap_computed(ex3)

# ╔═╡ 275c5f57-623d-439f-b09d-f7c745e0bed6
ex2 = @skip_as_script Expr(:call, :first, ex2_inner_result)

# ╔═╡ d414f840-4952-4de5-a565-7fdc81a94817
"The opposite of `@skip_as_script`"
macro only_as_script(ex) is_inside_pluto(__module__) ? nothing : esc(ex) end

# ╔═╡ 326825b0-a17f-427a-9056-8e8156098418
@skip_as_script "hello"

# ╔═╡ 64bf02a4-4fe3-424d-ae6e-5906c3395278
md"""
## PlutoUI favourites
"""

# ╔═╡ f3916810-1911-48bd-936b-776206fcad54
const toc_css = """
@media screen and (min-width: 1081px) {
	.plutoui-toc.aside {
		position:fixed; 
		right: 1rem;
		top: 5rem; 
		width:25%; 
		padding: 10px;
		border: 3px solid rgba(0, 0, 0, 0.15);
		border-radius: 10px;
		box-shadow: 0 0 11px 0px #00000010;
		/* That is, viewport minus top minus Live Docs */
		max-height: calc(100vh - 5rem - 56px);
		overflow: auto;
		z-index: 50;
		background: white;
	}
}

.plutoui-toc header {
	display: block;
	font-size: 1.5em;
	margin-top: 0.67em;
	margin-bottom: 0.67em;
	margin-left: 0;
	margin-right: 0;
	font-weight: bold;
	border-bottom: 2px solid rgba(0, 0, 0, 0.15);
}

.plutoui-toc section .toc-row {
	white-space: nowrap;
	overflow: hidden;
	text-overflow: ellipsis;
	padding-bottom: 2px;
}

.highlight-pluto-cell-shoulder {
	background: rgba(0, 0, 0, 0.05);
	background-clip: padding-box;
}

.plutoui-toc section a {
	text-decoration: none;
	font-weight: normal;
	color: gray;
}
.plutoui-toc section a:hover {
	color: black;
}

.plutoui-toc.indent section a.H1 {
	font-weight: 700;
	line-height: 1em;
}

.plutoui-toc.indent section a.H1 {
	padding-left: 0px;
}
.plutoui-toc.indent section a.H2 {
	padding-left: 10px;
}
.plutoui-toc.indent section a.H3 {
	padding-left: 20px;
}
.plutoui-toc.indent section a.H4 {
	padding-left: 30px;
}
.plutoui-toc.indent section a.H5 {
	padding-left: 40px;
}
.plutoui-toc.indent section a.H6 {
	padding-left: 50px;
}
"""

# ╔═╡ 122c27a5-a6e8-45ef-a968-b9b4b3f9ad09
const toc_js = toc -> """
const getParentCell = el => el.closest("pluto-cell")

const getHeaders = () => {
	const depth = Math.max(1, Math.min(6, $(toc.depth))) // should be in range 1:6
	const range = Array.from({length: depth}, (x, i) => i+1) // [1, ..., depth]
	
	const selector = range.map(i => `pluto-notebook pluto-cell h\${i}`).join(",")
	return Array.from(document.querySelectorAll(selector))
}

const indent = $(repr(toc.indent))
const aside = $(repr(toc.aside))

const render = (el) => html`\${el.map(h => {
	const parent_cell = getParentCell(h)

	const a = html`<a 
		class="\${h.nodeName}" 
		href="#\${parent_cell.id}"
	>\${h.innerText}</a>`
	/* a.onmouseover=()=>{
		parent_cell.firstElementChild.classList.add(
			'highlight-pluto-cell-shoulder'
		)
	}
	a.onmouseout=() => {
		parent_cell.firstElementChild.classList.remove(
			'highlight-pluto-cell-shoulder'
		)
	} */
	a.onclick=(e) => {
		e.preventDefault();
		h.scrollIntoView({
			behavior: 'smooth', 
			block: 'center'
		})
	}

	return html`<div class="toc-row">\${a}</div>`
})}`

const tocNode = html`<nav class="plutoui-toc">
	<header>$(toc.title)</header>
	<section></section>
</nav>`
tocNode.classList.toggle("aside", aside)
tocNode.classList.toggle("indent", aside)

const updateCallback = () => {
	tocNode.querySelector("section").replaceWith(
		html`<section>\${render(getHeaders())}</section>`
	)
}
updateCallback()


const notebook = document.querySelector("pluto-notebook")


// We have a mutationobserver for each cell:
const observers = {
	current: [],
}

const createCellObservers = () => {
	observers.current.forEach((o) => o.disconnect())
	observers.current = Array.from(notebook.querySelectorAll("pluto-cell")).map(el => {
		const o = new MutationObserver(updateCallback)
		o.observe(el, {attributeFilter: ["class"]})
		return o
	})
}
createCellObservers()

// And one for the notebook's child list, which updates our cell observers:
const notebookObserver = new MutationObserver(() => {
	updateCallback()
	createCellObservers()
})
notebookObserver.observe(notebook, {childList: true})

// And finally, an observer for the document.body classList, to make sure that the toc also works when if is loaded during notebook initialization
const bodyClassObserver = new MutationObserver(updateCallback)
bodyClassObserver.observe(document.body, {attributeFilter: ["class"]})

invalidation.then(() => {
	notebookObserver.disconnect()
	bodyClassObserver.disconnect()
	observers.current.forEach((o) => o.disconnect())
})

return tocNode
"""

# ╔═╡ 9126f47d-cbc7-411f-93bd-8684ba06c9e9
toc() = HTML("""
	<script>
	$(toc_js((;title="Table of Contents", indent=true, depth=3, aside=true)))
	</script>
	<style>
	$(toc_css)
	</style>
	""")

# ╔═╡ c763ed72-82c9-445c-a8f7-a0c40982e4d9
@skip_as_script toc()

# ╔═╡ 955705f9-c90d-495d-86b4-5f3b5bc9fc8e
begin
	struct Slider
		xs
	end
	
	Base.get(s::Slider) = first(s.xs)
	
	Base.show(io::IO, m::MIME"text/html", s::Slider) = show(io, m, @htl("<input type=range min=$(minimum(s.xs)) max=$(maximum(s.xs)) value=$(first(s.xs))>"))
	
	Slider
end

# ╔═╡ a6f82260-3519-4254-a21e-abc7bb19ec4e
@bind howmuch Slider(0:100)

# ╔═╡ c369b4b5-2fcf-4029-a1f6-352120b2fc4b
@bind n Slider(1:10)

# ╔═╡ 98992db9-4f14-4aa6-a7c5-477622266112
@bind k Slider(0:15)

# ╔═╡ 187c3005-cd43-45a0-8cbd-bc96b9cb39da
Dump(x; maxdepth=8) = sprint(io -> dump(io, x; maxdepth=maxdepth)) |> Text

# ╔═╡ a6709e08-964d-46ea-9813-2c70a834824b
@skip_as_script Dump(ex1)

# ╔═╡ 10803c0d-d0a5-45c5-b7ef-9659e441df69
@skip_as_script Dump(ex2)

# ╔═╡ 411271a6-4236-45e2-ab34-f26410108821
Dump(ex3)

# ╔═╡ ae82a36c-16a0-4bc3-8c0a-eff4277f1139
Dump(:(:(Base.show)))

# ╔═╡ 6c0156a9-7281-4326-9e1f-989efa73bb7b
begin
	struct Show{M <: MIME}
		mime::M
		data
	end

	Base.show(io::IO, ::M, x::Show{M}) where M <: MIME = write(io, x.data)
	
	Show
end

# ╔═╡ e46cf3e0-aa15-4c17-a925-3e9fc5109d54
Hannes = let
	url = "https://user-images.githubusercontent.com/6933510/116753174-fa40ab80-aa06-11eb-94d7-88f4171970b2.jpeg"
	data = read(download(url))
	Show(MIME"image/jpg"(), data)
end;

# ╔═╡ 6f5ba692-4b6a-405a-8cd3-1a8f9cc06611
plot(args...; kwargs...) = Hannes

# ╔═╡ 5b70aaf1-9623-4f55-b055-4263ed8be31d
Floep = let
	url = "https://user-images.githubusercontent.com/6933510/116753861-142ebe00-aa08-11eb-8ce8-684af1098935.jpeg"
	data = read(download(url))
	Show(MIME"image/jpg"(), data)
end;

# ╔═╡ bf2abe01-6ae0-4066-8704-12f64e04511b
friends = Any[Hannes, Floep];

# ╔═╡ 8d3df0c0-eb48-4dae-97a8-8c01f0b0a34b
md"## Pretty printing code"

# ╔═╡ dbd41240-9fc4-4e25-8b25-2b68afa679f2
struct EscapeExpr
	expr
end

# ╔═╡ 91e3e2b4-7966-42ee-8a45-31d6c5f08121
function Base.show(io::IO, val::EscapeExpr)
	print(io, "\$(esc(")
	print(io, val.expr)
	print(io, "))")
end

# ╔═╡ 7cc07d1b-7757-4428-8028-dc892bf05f2f
move_escape_calls_up(e::Expr) = begin
	
	args = move_escape_calls_up.(e.args)
	if all(x -> Meta.isexpr(x, :escape, 1), args)
		Expr(:escape, Expr(e.head, (arg.args[1] for arg in args)...))
	else
		Expr(e.head, args...)
	end
end

# ╔═╡ e0837338-e657-4bdc-ae91-1de9224da78d
move_escape_calls_up(x) = x

# ╔═╡ 64df4678-0721-4911-8289-fb18f55e6657
escape_syntax_to_esc_call(e::Expr) = if e.head === :escape
	EscapeExpr(e.args[1])
else
	Expr(e.head, (escape_syntax_to_esc_call(x) for x in e.args)...)
end

# ╔═╡ 58845ff9-821b-45d4-b5ec-96e1949bb277
escape_syntax_to_esc_call(x) = x

# ╔═╡ 4d5f44e4-85e9-4985-9b76-73be5e097186
remove_linenums(e::Expr) = if e.head === :macrocall
	Expr(e.head, (remove_linenums(x) for x in e.args)...)
else
	Expr(e.head, (remove_linenums(x) for x in e.args if !(x isa LineNumberNode))...)
end

# ╔═╡ dd495e00-d74d-47d4-a5d5-422fb147ec3b
remove_linenums(x) = x

# ╔═╡ ab0a19b8-cf7c-4c4f-802a-f85eef81fc02
function Base.show(io::IO, m::MIME"text/html", sd::SlottedDisplay)

	d, e = sd.d, sd.e
	
	s = sprint() do iobuffer
		print(IOContext(iobuffer, io), e |> remove_linenums)
	end
	
	lines = split(s, "\n")
	
	r = r"\_\_slot[a-z]{16}\_\_"
	embed_display
	h = @htl("""<slotted-code>
		$(
	map(lines) do l
		keys = [Symbol(m.match) for m in eachmatch(r, l)]
		rest = split(l, r; keepempty=true)
		
		result = vcat((
			[(isempty(r) ? @htl("") : preish(r)), embed_display(d[k].x)]
			for (r,k) in zip(rest, keys)
			)...)
		
		push!(result, preish(last(rest)))
		
		@htl("<line-like>$(result)</line-like>")
	end
	)
		</slotted-code>""")
	show(io, m, h)
end

# ╔═╡ b765dbfe-4e58-4bb9-b1d6-aa4378d4e9c9
expr_to_str(e, mod=@__MODULE__()) = let
	Computed
	sprint() do io
		Base.print(IOContext(io, :module => @__MODULE__), escape_syntax_to_esc_call(move_escape_calls_up(remove_linenums(e))))
	end
end

# ╔═╡ ef6fc423-f1b1-4dcb-a059-276121391bc6
prettycolors(e) = Markdown.MD([Markdown.Code("julia", expr_to_str(e))])

# ╔═╡ 235d5929-0d87-49ac-ae35-b45bb39804df
[:(1 + $(lonely_function)())] .|> prettycolors

# ╔═╡ 0f31dd2e-0331-4d4c-8db5-9ce188cd3730
[lens_to_getter(:source, [FieldLens(:x), PropertyLens(:y)])] .|> prettycolors

# ╔═╡ cecba3e6-98e8-408a-97dd-96b67c4f42cf
[lens_to_setter(:dest, [FieldLens(:x), PropertyLens(:y)], :value)] .|> prettycolors

# ╔═╡ 7e6c2162-97e9-4835-b650-52c9723c327f
md"## Utils"

# ╔═╡ 1ac164c8-88fc-4a87-a194-60ef616fb399
flatmap(args...) = vcat(map(args...)...)

# ╔═╡ 1c1b64b1-107e-4d43-9ce2-569c3034017e
function expr_lenses_for_quoted(e::Expr, code_loweredish_with_lenses)::Frames
	if e.head == :$
		frames = code_loweredish_with_lenses(e.args[1])
		apply_lens_to_frames([FieldLens(:args), PropertyLens(1)], frames)
	else
		argument_frames = flatmap(enumerate(e.args)) do (i, arg)
			frames = expr_lenses_for_quoted(arg, code_loweredish_with_lenses)
			apply_lens_to_frames([FieldLens(:args), PropertyLens(i)], frames)
		end
	end
end

# ╔═╡ ce90612e-ffc1-4e30-9d89-531f11fd75eb
"""
    code_loweredish_with_lenses(e::Expr)::Vector{ExprWithLens}

Transforms an expression into a set of list of expressions that would be executed one after eachother. It gives every expression a lens referencing where it is inside the original expression. This way you can execute each expr, and then put the result in the expression to create the step-by-step execution.

It doesn't "dedupe" the expressions, so when you run the last expression in the list (which will just be the original expression), it doesn't take advantage of any previously run expressions in the same list. You'll have to do that later, manually.

In PlutoTest this is done with [TODO](@ref)
"""
function code_loweredish_with_lenses(e::Expr)::Frames
	if e.head == :kw
		frames = code_loweredish_with_lenses(e.args[2])
		apply_lens_to_frames([FieldLens(:args), PropertyLens(2)], frames)
	elseif e.head == :(=)
		frames = code_loweredish_with_lenses(e.args[2])
		lens = [FieldLens(:args), PropertyLens(2)]
		[
			apply_lens_to_frames(lens, frames)...,
			ExprWithLens(expr=e.args[2], lens=lens, expr_to_show=e),
			# It now adds the whole `x = ...` expression as well,
			# which doesn't look that good in the output...
			# But we'll have to live with it for now
		]
	elseif e.head == :parameters
		flatmap(enumerate(e.args)) do (i, arg)
			frames = code_loweredish_with_lenses(arg)
			apply_lens_to_frames([FieldLens(:args), PropertyLens(i)], frames)
		end
	elseif e.head == :quote
		frames = expr_lenses_for_quoted(e.args[1], code_loweredish_with_lenses)
		argument_frames = apply_lens_to_frames(
			[FieldLens(:args), PropertyLens(1)],
			frames
		)
		[argument_frames..., ExprWithLens(expr=e, lens=[])]
	elseif e.head == :...
		frames = code_loweredish_with_lenses(e.args[1])
		apply_lens_to_frames([FieldLens(:args), PropertyLens(1)], frames)
	elseif e.head == :macrocall || e.head == :ref
		[ExprWithLens(expr=e, lens=[])]
	elseif e.head == :call
		# With calls we don't want to dive into the callee if it is just a symbol
		# (This would expand everything like x == y to #function(:==)(x,y) which
		# is definitely not what we want)
		possibly_callee_frames = if e.args[begin] isa Symbol
			[]
		else
			frames = code_loweredish_with_lenses(e.args[begin])
			apply_lens_to_frames([FieldLens(:args), PropertyLens(firstindex(e.args))], frames)
		end
		
		argument_frames = flatmap(enumerate(e.args[begin+1:end])) do (i, arg)
			frames = code_loweredish_with_lenses(arg)
			@info "III" i arg
			apply_lens_to_frames([FieldLens(:args), PropertyLens(i+1)], frames)
		end
		
		[possibly_callee_frames..., argument_frames..., ExprWithLens(expr=e, lens=[])]

	elseif (
		e.head == :begin ||
		e.head == :block ||
		e.head == :vect ||
		e.head == :string ||
		e.head == :. ||
		e.head == :tuple ||
		e.head == :let
	)
		argument_frames = flatmap(enumerate(e.args)) do (i, arg)
			frames = code_loweredish_with_lenses(arg)
			apply_lens_to_frames([FieldLens(:args), PropertyLens(i)], frames)
		end
		
		[argument_frames..., ExprWithLens(expr=e, lens=[])]
	elseif (
		e.head == :if ||
		e.head == :elseif ||
		e.head == :else ||
		e.head == :&& ||
		e.head == :|| ||
		e.head == :try ||
		e.head == :catch ||
		e.head == :finally
	)
		if ERROR_ON_UNKNOWN_EXPRESSION_TYPE
			error("Conditional statements (:$(e.head)) are not yet supported")
		else
			[ExprWithLens(expr=e, lens=[])]
		end
	else
		if ERROR_ON_UNKNOWN_EXPRESSION_TYPE
			error("code_loweredish_with_lenses called with unknown expression type (:$(e.head))")
		else
			[ExprWithLens(expr=e, lens=[])]
		end
	end
end;

# ╔═╡ e1c306e3-0a47-4149-a9fb-ec7ab380fa11
function step_by_step(expr)
	build_step_by_step_blocks
	
	lowered = code_loweredish_with_lenses(expr)
	expr_ref_lens = gensym("expr_ref")
	steps_lens = gensym("steps")
	quote
		begin
			expr = $(QuoteNode(expr))
			$steps_lens = Any[expr]
			$expr_ref_lens = Ref{Any}(expr)
			$(build_step_by_step_blocks(lowered;
				expr_ref_lens=expr_ref_lens,
				steps_lens=steps_lens,
			)...)
			$steps_lens
		end
	end
end

# ╔═╡ b6e8a170-12cc-4d97-905d-274e2609bfd8
function test(expr, extra_args...)
	step_by_step
	Test.test_expr!("", expr, extra_args...)
		
	quote
		local expr_raw = $(QuoteNode(expr))
		try			
			steps = $(step_by_step(expr))

			result = unwrap_computed(last(steps))
			
			if result === true
				CorrectCall(expr_raw, steps)
			# elseif result === false
			# 	WrongCall(expr_raw, steps)
			else
				WrongCall(expr_raw, steps)
			end
		catch e
			@info "e" e
			rethrow(e)
			# Error(expr_raw, e)
		end
	end
end

# ╔═╡ 9c3f6eab-b1c3-4607-add8-d6d7e468c11a
begin
	export @test
	
	macro test(main_expr, expr...)
		test;
		
		source = QuoteNode(__source__)
		orig_expr = QuoteNode(main_expr)
		quote
			pluto_result, julia_test_result = try
				result = $(test(main_expr, expr...))
				(result, Test.Returned(result isa CorrectCall, "", $(source)))
			catch err
				rethrow(err)
				(err, Test.Threw(err, Base.catch_stack(), $(source)))
			end

			try
				Test.do_test(julia_test_result, $(orig_expr))
			catch; end
			
			pluto_result
		end
	end
	
	function Base.show(io::IO, m::MIME"text/html", call::Union{WrongCall,CorrectCall,ErrorCall})
		

		infix = if Meta.isexpr(call.expr, :call)
			fname = call.expr.args[1]
			Meta.isbinaryoperator(fname)
		else
			false
		end
		
		classes = [
			"pluto-test", 
			"call",
			(isa(call,CorrectCall) ? "correct" : "wrong"),
			(isa(call,Pass) ? "pass" : "fail"),
			infix ? "infix-operator" : "prefix-operator",
		]
		
		result = @htl("""
		
		<div class=$(classes)>
			<script>
			
			const div = currentScript.parentElement
			div.addEventListener("click", (e) => {
				if(!div.classList.contains("expanded") || e.target.closest("pt-dot:not(.floating)") != null){
					div.classList.toggle("expanded")
					e.stopPropagation()
				}
			})
			
			const throttled = (f, delay) => {
				const waiting = { current: false }
				return () => {
					if (!waiting.current) {
						f()
						waiting.current = true
						setTimeout(() => {
							f()
							waiting.current = false
						}, delay)
					}
				}
			}
			
			const dot = div.querySelector("pt-dot")
			const dot_top = div.querySelector("pt-dot.top")
			const dot_bot = div.querySelector("pt-dot.bottom")
			
			const is_chrome = /Chrome/.test(navigator.userAgent) && /Google Inc/.test(navigator.vendor)
			const is_firefox = /Firefox/.test(navigator.userAgent) && /Mozilla/.test(navigator.userAgent)
			
			// safari is too slow
			
			if(is_chrome || is_firefox){

			const intersect = (r) => {
				const topdistance = r.top
				const botdistance = window.innerHeight - r.bottom
			
				
				const t = (x) => `translate(\${2*Math.sqrt(Math.max(0,-50-x))}px,0)`
				dot_top.style.transform = t(topdistance)
				dot_bot.style.transform = t(botdistance)

				div.classList.toggle("show-top-float", topdistance < 4)
				div.classList.toggle("show-bottom-float", botdistance < 4)
			}
			
			intersect(dot.getBoundingClientRect())
			
			const scroll_listener = throttled(() => {
				intersect(dot.getBoundingClientRect())
			}, 200)
			
			window.addEventListener("scroll", scroll_listener)

			let observer = new IntersectionObserver((es) => {
				const e = es[0]
				intersect(e.boundingClientRect)
			},  {
			  rootMargin: '-4px',
			  threshold: 1.0
			});

			observer.observe(dot)
			invalidation.then(() => {
				window.removeEventListener("scroll", scroll_listener)
				observer.unobserve(dot)
			})
			
			Array.from(div.querySelectorAll("pt-dot.floating")).forEach(e => {
				e.addEventListener("click", () => dot.scrollIntoView({behavior: "smooth", block: "center", inline: "nearest"}))
			})
			
			}
			
			</script>
			<pt-dot></pt-dot>
			<pt-dot class="floating top"></pt-dot>
			<pt-dot class="floating bottom"></pt-dot>
		
			$(frames(SlottedDisplay.( call.steps)))
		</div>
		<style>
		$(pluto_test_css.code)
		$(slotted_code_css.code)
		</style>
		
		
		""")
		Base.show(io, m, result)
	end
end

# ╔═╡ 73d74146-8f60-4388-aaba-0dfe4215cb5d
@test sqrt(20-11) == 3

# ╔═╡ 71b22e76-2b50-4d16-85f6-9dad0415630e
@test iseven(123 + 7^3)

# ╔═╡ 6762ed72-f422-43a9-a782-de78f739c0ae
@test 4+4 ∈ [1:7...]

# ╔═╡ f77275b9-90aa-4e07-a608-981b5df727af
@test is_good_boy(first(friends))

# ╔═╡ 37529063-8ee9-46a6-85cc-94db292da541
@test sqrt(sqrt(16)) == sqrt(2)

# ╔═╡ eab4ba31-c787-46dd-8024-693eca7fd1a0
@test x == [1,2+2]

# ╔═╡ 26b0faf0-9016-48d7-8667-c1c1cfce655e
@test missing == 2

# ╔═╡ 26b4fb86-892f-415c-8046-6a5449052fd7
@test 2+2 == 2+2

# ╔═╡ 96dc7b01-3766-4206-88ba-eca1665bc5cb
@test rand(50) == [rand(50),2]

# ╔═╡ 7c6ce205-053d-434c-b5b1-500babb8ec02
@test always_false(rand(howmuch), rand(howmuch),123)

# ╔═╡ fe7f8cce-a706-476d-8680-a2fe793b474f
@test always_false(rand(2), rand(2),123)

# ╔═╡ 8d340983-ea07-4038-872f-22a165003ed2
@test isless(2+2,1)

# ╔═╡ ea5a4fc0-db62-41dd-9600-a21d4eabf822
@test isless(1,2+2)

# ╔═╡ 4509cdbf-8b8b-4f70-9e63-bb972eb88c93
@test iseven(n^2)

# ╔═╡ 8360d1bc-b1f4-4263-a042-724cbd120227
@test 4+4 ∈ [1:k...]

# ╔═╡ 064e28de-0c22-48b5-b427-6eb343880287
@test isempty((1:k) .^ 2)

# ╔═╡ be93a6f4-b626-43db-a2fe-4e754e79c030
@test isempty([1,sqrt(2)])

# ╔═╡ e9370ce7-24ff-475a-ae47-c1de3eaeac7a
begin
	i = 8
	@test sqrt(i) < 3
end

# ╔═╡ 17bd5cd9-212f-4656-ab79-590dd6c64ff8
@test 1 ∈ [sqrt(20), 5:9...]

# ╔═╡ 539e2c38-993b-4b3b-8aa0-f02d46d79839
@test 1 ∈ rand(60)

# ╔═╡ 3d3f3592-e056-4e7b-8896-a75e5b5dcad6
@test rand(60) ∋ 1

# ╔═╡ c39021dc-157c-4bcb-a3a9-fec8d9286b48
map(1:15) do iii
	try
		@test 2 * iii > 0.19
	catch e
		e
	end
end

# ╔═╡ cbab6234-5821-4a89-ab4e-e030d3494711
@test 2 * 5 > 0.19

# ╔═╡ bb770f3f-72dd-4a71-8d71-9e773224df05
t = @test always_false(rand(20), rand(20),123)

# ╔═╡ ceb8dc07-dc1b-4b76-b08f-d65f3754df3b
@test x = 3 - sqrt(16)

# ╔═╡ 176f39f1-fa36-4ce1-86ba-76248848a834
@skip_as_script @test (@test always_false(rand(30),123)) isa Fail

# ╔═╡ 716bba60-bfbb-48a4-8924-8bf4e8958cb1
@test always_false("asd"*"asd","asd","asd"*" asd","asd","asd"*"asd","asd","asd"*"asd","asd","asd"*"asd","asd","asd"*"asd","asd","asd"*"asd","asd")

# ╔═╡ 7c1aa057-dff2-48cd-aad5-1bbc1c0a729b
@test π ≈ 3.14 atol=0.01 rtol=1

# ╔═╡ 9741e0d3-d61d-48f4-a80d-b8b24e896190
@test [1, sqrt(sqrt(2)), 8^7]

# ╔═╡ ecee13ed-7fad-4d1c-938e-02a1627cd4ff
@test error("whaaat")

# ╔═╡ d2e1d5ae-2daa-4cf1-8cd9-68bb8c6c81a1
@test let
	executed_count = Ref(0)
	steps = @test(begin
		sqrt(sqrt(increase_counter(16, executed_count)))
	end)
	
	executed_count[] == 2
end

# ╔═╡ dd69966b-041f-4a87-925a-2925496ca280
@test :((Base.show + 1) + 5)

# ╔═╡ 58fd43c1-4775-431f-a835-43972b4da6c4
@test (10 + 1) + 5

# ╔═╡ 40902263-04b9-4022-b156-a19bdb0b568c
[@macroexpand1 @test x = 3 - sqrt(16)] .|> prettycolors

# ╔═╡ 6e9ba6e0-ec85-4e5e-9ae2-358cf45ce18c
@test x = 3 - sqrt(16)

# ╔═╡ a661e172-6afb-42ff-bd43-bb5b787ee5ed
macro eval_step_by_step(e)
	step_by_step(e)
end

# ╔═╡ 3fccae0c-ab69-4bc8-858b-ede886c45e32
(@eval_step_by_step sqrt(sqrt(4)) + 2) .|> prettycolors

# ╔═╡ c46d5246-e62f-4f2e-9e3a-0608c8c48b2e
(@eval_step_by_step 4+4 ∈ [1:7...]) .|> prettycolors

# ╔═╡ 7cac2b5d-4de9-469c-9158-0f935a27ed2d
(@eval_step_by_step is_good_boy(first(friends))) .|> prettycolors

# ╔═╡ d7dc79e6-1f58-4414-aeef-667bdb0dd200
macro pretty_step_by_step(e)
	eval_by_step = var"@eval_step_by_step"
	quote
		$(Expr(:macrocall, eval_by_step, __source__, e)) .|> prettycolors
	end
end

# ╔═╡ 8150cb7e-b2e2-4ee8-a475-db4454c954f0
@pretty_step_by_step embed_display(@test sqrt(sqrt(16)) == 2)

# ╔═╡ bc6c6555-95e9-4515-ab98-422551b846d0
let
	i = 10
	@pretty_step_by_step i * 2
end

# ╔═╡ ba4a5762-33da-40e6-94fa-cca9befc6d5a
example_equals = @skip_as_script let
	@pretty_step_by_step sqrt(sqrt(16)) == 4
end

# ╔═╡ 9101631b-81ca-4c7c-94da-81d9e106df78
example_call_spread = @skip_as_script let
	@pretty_step_by_step max([1,2,3]...) != min([1,2,3]...)
end

# ╔═╡ 3f0e5a49-5eec-42cd-bd2c-254b277840bf
example_show_variable_value = @skip_as_script let
	x = [1,2,3]
	@pretty_step_by_step x == [1,2,3]
end

# ╔═╡ 1aa319c8-5e1d-4dd9-ae22-ad99e46e7b4d
example_keyword_arguments = @skip_as_script let
	@pretty_step_by_step round(sqrt(2), digits=Int(sqrt(16)))
end

# ╔═╡ 605d2481-23be-4ad9-82c9-e375b7be8669
# Seems very similar to `example_keyword_arguments`, but this one
# has a `;`, which makes a liiiitle bit different AST
example_keyword_arguments_explicit = @skip_as_script let
	@pretty_step_by_step round(sqrt(2); digits=Int(sqrt(16)))
end

# ╔═╡ 68ba60db-44ad-43e4-b33e-d27696babc99
@pretty_step_by_step sqrt(sqrt(length([1,2])))

# ╔═╡ 807bcd72-26c3-44d3-a295-56874cb51a89
@pretty_step_by_step xasdf = 123

# ╔═╡ 60a398c9-9fe8-4b90-b863-1568183641d9
example_returned_function = @skip_as_script let
	function_that_returns_function = () -> function X() 10 end
	@pretty_step_by_step function_that_returns_function()() == 10
end

# ╔═╡ b4b317d7-bed1-489c-9650-8d336e330689
rs = @eval_step_by_step(begin
		(1+2) + (7-6)
		plot(2000 .+ 30 .* rand(2+2))
		4+5
		sqrt(sqrt(sqrt(5)))
	end) .|> SlottedDisplay

# ╔═╡ 93ed973f-daf6-408b-9d4b-d53495418610
@bind rindex Slider(eachindex(rs))

# ╔═╡ dea898a0-1904-4d09-ad0b-6915008fe946
rs[rindex]

# ╔═╡ 74c19786-1ba7-4865-a993-590a779ae564
frames(rs)

# ╔═╡ 326f7661-3482-4bf2-a97b-57cc7ac60ee2
macro visual_debug(expr)
	frames
	SlottedDisplay
	var"@eval_step_by_step"
	with_slotted_css
	quote
		@eval_step_by_step($(expr)) .|> SlottedDisplay |> frames |> with_slotted_css
	end
end

# ╔═╡ a2cbb0c3-23b9-4091-9ca7-5ba96e85e3a3
@visual_debug begin
	(1+2) + (7-6)
	plot(2000 .+ 30 .* rand(2+2))
	4+5
	sqrt(sqrt(sqrt(5)))
	md"#### Wow"
end

# ╔═╡ 03579ca6-d04b-4ba7-829c-8cf3c3fdbafa
build_step_by_step_blocks(code_loweredish_with_lenses(:(sqrt(sqrt(1))))) .|> prettycolors

# ╔═╡ 3650d813-8a6c-4cd0-bb68-8b384e8211d8
build_step_by_step_blocks(code_loweredish_with_lenses(quote
	@test 1 + 1
end)) .|> prettycolors

# ╔═╡ 6e1f66f2-9b73-4bb6-bc23-b4483ddfca97
code_loweredish_with_lenses(eee)

# ╔═╡ Cell order:
# ╟─ab02837b-79ec-40d7-bff1-c1d2dd7362ef
# ╠═73d74146-8f60-4388-aaba-0dfe4215cb5d
# ╠═71b22e76-2b50-4d16-85f6-9dad0415630e
# ╠═6762ed72-f422-43a9-a782-de78f739c0ae
# ╠═f77275b9-90aa-4e07-a608-981b5df727af
# ╠═37529063-8ee9-46a6-85cc-94db292da541
# ╟─56347b7e-5007-45f8-8f6d-8ac8cc719637
# ╟─bf2abe01-6ae0-4066-8704-12f64e04511b
# ╟─e46cf3e0-aa15-4c17-a925-3e9fc5109d54
# ╟─5b70aaf1-9623-4f55-b055-4263ed8be31d
# ╟─fd8428a3-9fa3-471a-8b2d-5bbb8fdb3137
# ╟─191f1f04-18d4-485b-af8b-a2f073b7043b
# ╟─ec1fd70a-d92a-4688-98b2-135879f07141
# ╠═cf314b21-3f4f-4637-b1ce-ec1d5d5af966
# ╠═c763ed72-82c9-445c-a8f7-a0c40982e4d9
# ╠═9d49ea50-8158-4d8b-97af-edba1f7dc38b
# ╠═eab4ba31-c787-46dd-8024-693eca7fd1a0
# ╠═26b0faf0-9016-48d7-8667-c1c1cfce655e
# ╠═26b4fb86-892f-415c-8046-6a5449052fd7
# ╠═96dc7b01-3766-4206-88ba-eca1665bc5cb
# ╠═7c6ce205-053d-434c-b5b1-500babb8ec02
# ╠═a6f82260-3519-4254-a21e-abc7bb19ec4e
# ╠═fe7f8cce-a706-476d-8680-a2fe793b474f
# ╠═8d340983-ea07-4038-872f-22a165003ed2
# ╠═ea5a4fc0-db62-41dd-9600-a21d4eabf822
# ╠═c369b4b5-2fcf-4029-a1f6-352120b2fc4b
# ╠═4509cdbf-8b8b-4f70-9e63-bb972eb88c93
# ╠═98992db9-4f14-4aa6-a7c5-477622266112
# ╠═8360d1bc-b1f4-4263-a042-724cbd120227
# ╠═064e28de-0c22-48b5-b427-6eb343880287
# ╠═be93a6f4-b626-43db-a2fe-4e754e79c030
# ╠═e9370ce7-24ff-475a-ae47-c1de3eaeac7a
# ╟─17bd5cd9-212f-4656-ab79-590dd6c64ff8
# ╟─539e2c38-993b-4b3b-8aa0-f02d46d79839
# ╟─3d3f3592-e056-4e7b-8896-a75e5b5dcad6
# ╠═1aa24b1c-e8ca-4de7-b614-7a3f02b4833d
# ╠═b0ab9327-8240-4d34-bdd9-3f8f5117bb29
# ╟─1e619ca9-e00f-46d0-b327-85b33929787f
# ╟─8a2e8348-49cf-4855-b5b3-cdee33e5ed67
# ╟─42671258-07a0-4015-8f47-4b3032595f08
# ╟─0d70962a-3880-4dee-a439-35068d019f5a
# ╠═113cc425-e224-4f77-bfbd-ef4eb1d1ed70
# ╠═6188f559-bcab-4da6-84b2-a3fe522a5c3c
# ╠═c24b46ce-bcbb-4dc9-8a59-b5b1bd2cd617
# ╠═5041085e-a406-4ed4-ab82-84d8f126cf0f
# ╠═8c92bad9-234e-47dd-a599-b75dc6d5db89
# ╠═03ccd498-83c3-41bb-84d7-625adabd7aee
# ╠═1bcf8bd1-c8a3-49a1-9791-d813aa856399
# ╠═656c4190-b49e-4225-869d-eeb7e8e41e72
# ╠═14c525a1-eca1-466b-8e63-3a90d7d7111c
# ╟─a2efc968-246c-40c2-b285-2ec94b185a44
# ╠═c39021dc-157c-4bcb-a3a9-fec8d9286b48
# ╠═cbab6234-5821-4a89-ab4e-e030d3494711
# ╠═e1c306e3-0a47-4149-a9fb-ec7ab380fa11
# ╠═b6e8a170-12cc-4d97-905d-274e2609bfd8
# ╟─bfe4dc61-9160-4c7e-8897-9c723b309adc
# ╠═bb770f3f-72dd-4a71-8d71-9e773224df05
# ╠═ceb8dc07-dc1b-4b76-b08f-d65f3754df3b
# ╠═176f39f1-fa36-4ce1-86ba-76248848a834
# ╠═8150cb7e-b2e2-4ee8-a475-db4454c954f0
# ╠═716bba60-bfbb-48a4-8924-8bf4e8958cb1
# ╠═7c1aa057-dff2-48cd-aad5-1bbc1c0a729b
# ╠═9741e0d3-d61d-48f4-a80d-b8b24e896190
# ╠═ecee13ed-7fad-4d1c-938e-02a1627cd4ff
# ╠═9c3f6eab-b1c3-4607-add8-d6d7e468c11a
# ╟─dbfbcc16-c740-436c-bbf0-fee16b0a20c5
# ╠═d97987a0-bdc0-46ed-a6a5-f35c1ce961dc
# ╠═a6709e08-964d-46ea-9813-2c70a834824b
# ╟─7c2bab29-8609-4575-b2ca-7feb34915645
# ╠═69bfb438-7ecf-4f9b-8bc4-51e07aa46ef1
# ╟─838b5904-1de2-4d9f-8f3c-a93ec224d40e
# ╠═a3c41025-2f4a-4f9c-8577-72e4b7abbb98
# ╠═3e79ff61-6532-4879-9402-86473aa7d960
# ╠═275c5f57-623d-439f-b09d-f7c745e0bed6
# ╠═10803c0d-d0a5-45c5-b7ef-9659e441df69
# ╟─b056a99d-5b13-47ba-a199-d788410e3c99
# ╟─5b093e83-78c1-4187-b406-56e79800e1be
# ╠═a461f1fd-b5a5-4ae3-a47c-067a6081fb24
# ╠═38e54516-cdf4-4c1d-815b-68e1e7a7f6f7
# ╠═411271a6-4236-45e2-ab34-f26410108821
# ╟─f9c81ab1-556c-4d81-bee8-2897c20e324d
# ╠═a392d2d6-5a16-4383-b0ef-5003aa2de9fa
# ╠═ae95b691-f54b-4bf5-b17b-3e5bd1edf75e
# ╠═12119016-fa61-4d38-8c58-821ea435df7d
# ╠═9bed78b6-5a8f-44ce-ab66-cab685daf264
# ╟─2c1b906d-71b9-430e-83ed-d4c8c0018632
# ╠═3fccae0c-ab69-4bc8-858b-ede886c45e32
# ╠═c46d5246-e62f-4f2e-9e3a-0608c8c48b2e
# ╠═7cac2b5d-4de9-469c-9158-0f935a27ed2d
# ╠═03579ca6-d04b-4ba7-829c-8cf3c3fdbafa
# ╠═b46b02b7-242a-48bf-bac8-8a3b6474384b
# ╠═235d5929-0d87-49ac-ae35-b45bb39804df
# ╟─7db64b02-8f64-4146-bf77-ef94cb45aae0
# ╠═886c8080-cd29-4c72-898b-4fbd3a988e4d
# ╠═d2e1d5ae-2daa-4cf1-8cd9-68bb8c6c81a1
# ╠═bc6c6555-95e9-4515-ab98-422551b846d0
# ╠═3650d813-8a6c-4cd0-bb68-8b384e8211d8
# ╠═ae82a36c-16a0-4bc3-8c0a-eff4277f1139
# ╠═dd69966b-041f-4a87-925a-2925496ca280
# ╠═58fd43c1-4775-431f-a835-43972b4da6c4
# ╟─ec6f1b07-d026-45ca-996d-be7693664cd7
# ╟─dadf1c50-6588-4345-a240-69a72336c7cd
# ╠═c335fea6-6bf5-489f-9218-de67e45c38a8
# ╟─a29d5277-e97a-4cca-8e31-8037f9cfdd80
# ╟─4f7aac13-9e49-4b2b-8d78-53f583f6130a
# ╠═f5d9a4c5-300f-4dae-8507-346ec0b74632
# ╟─74929fa6-d1f7-41cd-ab55-48f35d5fbf28
# ╠═2f6e353d-2cdc-46d6-9727-01b0a6167ca0
# ╠═17dea9e5-84ea-4476-a318-cc475043c83b
# ╠═5e66e59b-fdb8-4373-b231-097b0227dc5c
# ╠═40902263-04b9-4022-b156-a19bdb0b568c
# ╠═779c75cf-b35d-439c-87b7-b42740d2c870
# ╠═6e9ba6e0-ec85-4e5e-9ae2-358cf45ce18c
# ╠═67ad5781-e8bd-4f13-a03e-dcc5773574a0
# ╠═c2e3377d-a456-40a1-b904-d285d47b50c6
# ╠═37e2d966-0f46-4b64-bb3a-c057e344fa02
# ╠═6e1f66f2-9b73-4bb6-bc23-b4483ddfca97
# ╠═bcff728d-0781-44ce-8033-9f642207a475
# ╠═ce90612e-ffc1-4e30-9d89-531f11fd75eb
# ╟─0a3f5c6c-6e1b-458c-bf91-523a0b639b41
# ╟─43fe89d7-f33e-4dfa-853e-327e981feb1e
# ╟─fc000550-3053-483e-bc41-6aed22c3999c
# ╟─3f11ca4c-dd06-47c9-92e2-cb97c18a06db
# ╟─b155d336-f746-4c82-8206-ab1a49cedea8
# ╟─221aa13b-aa25-4145-8076-da77432364bb
# ╟─2a514f2f-79c8-4b0d-be8a-170f3386d5d5
# ╟─9fb4d52d-77f2-4032-a769-6d5e60be43bf
# ╟─1c1b64b1-107e-4d43-9ce2-569c3034017e
# ╟─cade56ad-312e-40cf-bcda-11480ce27852
# ╠═d384e3fc-b207-48ce-bc7b-1b47a14b1581
# ╠═d7dc79e6-1f58-4414-aeef-667bdb0dd200
# ╠═a661e172-6afb-42ff-bd43-bb5b787ee5ed
# ╟─a6e8c835-f209-445a-9f43-cdf2ecfd1b57
# ╟─5759b2cc-1e96-4069-ae42-bc159c7cf5fb
# ╟─ba4a5762-33da-40e6-94fa-cca9befc6d5a
# ╠═9101631b-81ca-4c7c-94da-81d9e106df78
# ╠═3f0e5a49-5eec-42cd-bd2c-254b277840bf
# ╟─716d9ddc-18dc-4973-924e-e5ebf9161ff6
# ╟─1aa319c8-5e1d-4dd9-ae22-ad99e46e7b4d
# ╟─605d2481-23be-4ad9-82c9-e375b7be8669
# ╠═68ba60db-44ad-43e4-b33e-d27696babc99
# ╠═807bcd72-26c3-44d3-a295-56874cb51a89
# ╟─de94f2b5-96ae-4936-870f-7639a39fd40d
# ╠═60a398c9-9fe8-4b90-b863-1568183641d9
# ╟─21d4560e-721f-4ed4-9db7-86a8151ab22c
# ╟─99afc7f4-727c-4277-8311-f2ffa94830ae
# ╠═4956526a-daf9-43c9-bff3-ff2446016e2e
# ╠═84ff6a23-c134-4910-b630-a7ad45f3bf29
# ╠═318363d0-6d9e-4144-b478-b775f437edaf
# ╠═67fd07b7-340b-4e24-bc06-e4c85b186872
# ╟─c6d5597c-d505-4125-88c4-10415934d2a4
# ╠═872b4877-30dd-4a92-a3c8-69eb50675dcb
# ╠═c877c109-db16-468c-8f3c-8294db859d6d
# ╠═ab0a19b8-cf7c-4c4f-802a-f85eef81fc02
# ╟─8480d0d7-bdf7-468d-9344-5b789e33921c
# ╠═6f5ba692-4b6a-405a-8cd3-1a8f9cc06611
# ╠═b4b317d7-bed1-489c-9650-8d336e330689
# ╠═93ed973f-daf6-408b-9d4b-d53495418610
# ╠═dea898a0-1904-4d09-ad0b-6915008fe946
# ╟─b5763c10-e11c-4389-b6fc-421d2c9682f1
# ╠═74c19786-1ba7-4865-a993-590a779ae564
# ╟─e968fc57-d850-4e2d-9410-8777d03b7b3c
# ╟─3d5abd58-02ab-4b91-a7a3-d9068d4df017
# ╟─326f7661-3482-4bf2-a97b-57cc7ac60ee2
# ╟─b273d3d3-648f-4d34-94e7-e49277d4ba29
# ╠═a2cbb0c3-23b9-4091-9ca7-5ba96e85e3a3
# ╟─34f613a3-85fb-45a8-be3b-cd8e6b3cb5a2
# ╟─f9ed2487-a7f6-4ce9-b673-f8a298cd5fc3
# ╟─20166ec9-7084-4d58-8b19-3aa51cc8f2c6
# ╠═0f31dd2e-0331-4d4c-8db5-9ce188cd3730
# ╠═cecba3e6-98e8-408a-97dd-96b67c4f42cf
# ╠═1633fe05-cb51-4032-b6b6-f23db72bbd49
# ╠═7c312943-c48b-40e7-a499-227f7ff8aa59
# ╠═a0207e25-0398-4104-8c0f-a8fbd9fe1d53
# ╟─7d14b79c-74e5-4986-80b7-de7cd7d48670
# ╟─5950488e-2008-48d8-9095-7f9421df191e
# ╟─77cc33a3-c2bc-4f2d-ba88-e3693ec79b0c
# ╟─5a3a0f63-dcce-49c9-84fd-a6317184820f
# ╟─35f63c4e-3583-4ea8-a057-31f18f8a09d6
# ╟─ef59d0f0-0f02-4089-a49d-53fb0427c3a0
# ╟─35b2770e-1db6-4327-bf86-c27a4b61dbd3
# ╠═22640a2f-ea38-4517-a4f3-7a65e60ffebe
# ╟─d414f840-4952-4de5-a565-7fdc81a94817
# ╠═326825b0-a17f-427a-9056-8e8156098418
# ╟─64bf02a4-4fe3-424d-ae6e-5906c3395278
# ╟─f3916810-1911-48bd-936b-776206fcad54
# ╟─122c27a5-a6e8-45ef-a968-b9b4b3f9ad09
# ╟─9126f47d-cbc7-411f-93bd-8684ba06c9e9
# ╟─955705f9-c90d-495d-86b4-5f3b5bc9fc8e
# ╟─187c3005-cd43-45a0-8cbd-bc96b9cb39da
# ╟─6c0156a9-7281-4326-9e1f-989efa73bb7b
# ╟─8d3df0c0-eb48-4dae-97a8-8c01f0b0a34b
# ╟─ef6fc423-f1b1-4dcb-a059-276121391bc6
# ╠═b765dbfe-4e58-4bb9-b1d6-aa4378d4e9c9
# ╟─dbd41240-9fc4-4e25-8b25-2b68afa679f2
# ╟─91e3e2b4-7966-42ee-8a45-31d6c5f08121
# ╟─7cc07d1b-7757-4428-8028-dc892bf05f2f
# ╟─e0837338-e657-4bdc-ae91-1de9224da78d
# ╟─64df4678-0721-4911-8289-fb18f55e6657
# ╟─58845ff9-821b-45d4-b5ec-96e1949bb277
# ╟─4d5f44e4-85e9-4985-9b76-73be5e097186
# ╟─dd495e00-d74d-47d4-a5d5-422fb147ec3b
# ╟─7e6c2162-97e9-4835-b650-52c9723c327f
# ╠═1ac164c8-88fc-4a87-a194-60ef616fb399
