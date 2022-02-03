### A Pluto.jl notebook ###
# v0.17.7

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
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

# ╔═╡ 191f1f04-18d4-485b-af8b-a2f073b7043b
md"""
## Installation and more info

> [github.com/JuliaPluto/PlutoTest.jl](https://github.com/JuliaPluto/PlutoTest.jl)
"""

# ╔═╡ ec1fd70a-d92a-4688-98b2-135879f07141
md"""
### (You need `Pluto ≥ 0.14.5` to run this notebook)
"""

# ╔═╡ 78704300-0531-4f8e-8aa5-3f588fbdd190
import Test: Test, @test_warn, @test_nowarn, @test_logs, @test_skip, @test_broken, @test_throws, @test_deprecated

# ╔═╡ 9129342b-f560-4901-81a2-56e3f8641521
export @test_nowarn, @test_warn, @test_logs, @test_skip, @test_broken, @test_throws, @test_deprecated

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

# ╔═╡ 03ccd498-83c3-41bb-84d7-625adabd7aee
struct CorrectCall <: Pass
	expr::Code
	steps::Vector
end

# ╔═╡ 1bcf8bd1-c8a3-49a1-9791-d813aa856399
Base.@kwdef struct ErrorCall <: Fail
	expr::Code
	steps::Vector
	error::CapturedException
end

# ╔═╡ 14c525a1-eca1-466b-8e63-3a90d7d7111c
struct WrongCall <: Fail
	expr::Code
	steps::Vector
end

# ╔═╡ a2efc968-246c-40c2-b285-2ec94b185a44
md"""
# Test macro
"""

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
## `Computed` struct

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

# ╔═╡ 74929fa6-d1f7-41cd-ab55-48f35d5fbf28
md"""
## `code_loweredish_with_lenses`
"""

# ╔═╡ f1ede628-d158-4296-befd-3eaa87cdad27
md"""
`ERROR_ON_UNKNOWN_EXPRESSION_TYPE` is set so when you view this notebook, you get explicit errors whenever we reach things we can't parse now but can work around.

Examples like this are `try ... catch ... end`, which we can't parse yet (control flow stuff is complex >_>) but we can still just evaluate that whole thing and call it a day.
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

# ╔═╡ c47252b9-8869-4878-b9bf-7eeb7ed17c9a
struct CantStepifyThisYetException <: Exception
	expr
end

# ╔═╡ 0a3f5c6c-6e1b-458c-bf91-523a0b639b41
md"""
### `code_loweredish_with_lenses` for all non-Expr types
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

# ╔═╡ f9b2a11d-8c4e-47a5-9d93-38025fae9a95
code_loweredish_with_lenses(::Char) = ExprWithLens[]

# ╔═╡ 221aa13b-aa25-4145-8076-da77432364bb
code_loweredish_with_lenses(x::LineNumberNode) = ExprWithLens[]

# ╔═╡ 2a514f2f-79c8-4b0d-be8a-170f3386d5d5
code_loweredish_with_lenses(x) = error("Type of expression not supported ($(typeof(x)))")
# code_loweredish_with-lenses(x) = [ExprWithLens(expr=x, lens=[])]

# ╔═╡ 9fb4d52d-77f2-4032-a769-6d5e60be43bf
md"""
### `expr_lenses_for_quoted`
Which will ignore everything except `:$` expressions, and then call `code_loweredish_with_lenses` for those.
"""

# ╔═╡ cade56ad-312e-40cf-bcda-11480ce27852
expr_lenses_for_quoted(x, _) = ExprWithLens[]

# ╔═╡ 810470b8-0a6c-48b8-aba2-a2058b8d9f59
md"## `build_step_by_step_blocks`" 

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

# ╔═╡ cc7102e1-6af0-43bb-8cf0-43e2cec210e3
Base.@kwdef struct PartialEvaluatedException <: Exception
	expr_with_lens::ExprWithLens
	steps::Vector
	error::CapturedException
end

# ╔═╡ ec6f1b07-d026-45ca-996d-be7693664cd7
deepcopy_expr(e::Expr) = Expr(e.head, (deepcopy_expr(sub_e) for sub_e in e.args)...)

# ╔═╡ dadf1c50-6588-4345-a240-69a72336c7cd
deepcopy_expr(e) = e

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
# Tests for all expression types
"""

# ╔═╡ 5759b2cc-1e96-4069-ae42-bc159c7cf5fb
md"## Basic"

# ╔═╡ 716d9ddc-18dc-4973-924e-e5ebf9161ff6
md"## Edge cases"

# ╔═╡ bc08755d-721f-403e-af95-36494b8fb7bc
md"## Things we can't parse yet"

# ╔═╡ de94f2b5-96ae-4936-870f-7639a39fd40d
md"""
> TODO  
>
> Functions that aren't just coming from simple references (so say, Higher-order functions and such) should actually get a mention in the time travel. Right now it is still as this odd `#X#123` thingy (which is even worse when it is anonymous..), but this we could make prettier later.
"""

# ╔═╡ 21d4560e-721f-4ed4-9db7-86a8151ab22c
md"""
# UI
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
## SlottedDisplay

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

# ╔═╡ b5763c10-e11c-4389-b6fc-421d2c9682f1
md"""
## Frame viewer

A widget that takes a series of elements and displays them as 'video frames' with a timeline scrubber.
"""

# ╔═╡ 3d5abd58-02ab-4b91-a7a3-d9068d4df017
md"""
## @visual_debug (awesome)
"""

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
quote_if_needed(x::Union{Expr, Symbol, QuoteNode, LineNumberNode}) = QuoteNode(x)

# ╔═╡ 5950488e-2008-48d8-9095-7f9421df191e
quote_if_needed(x) = x

# ╔═╡ 77cc33a3-c2bc-4f2d-ba88-e3693ec79b0c
function lens_to_setter(subject, lens::Vector, value)
	if length(lens) === 0
		throw(ArgumentError("lens needs at least one element in path"))
	elseif length(lens) === 1
		property = lens[1]
		if property isa FieldLens
			:($subject.$(property.property) = $value)
		elseif property isa PropertyLens
			:($subject[$(quote_if_needed(property.property))] = $value)
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
			:($subject[$(quote_if_needed(property.property))])
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
		:($subject[$(quote_if_needed(property.property))])
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
			try
				$(expr_ref_lens == :EXPR_REF_LENS_DEFAULT ? :(error("expr_ref_lens wasn't assigned, so this code will not work, but you can see and inspect it")) : nothing)
				$(steps_lens == :STEPS_LENS_DEFAULT ? :(error("steps_lens wasn't assigned, so this code will not work, but you can see and inspect it")) : nothing)
	
				val = $(expr_with_arguments_as_references)
				
				# Could use Accessors.jl to make this a lot less expensive... 🤷‍♀️
				$expr_ref_lens[] = $(deepcopy_expr)($expr_ref_lens[])
				$(lens_to_setter(
					expr_ref_lens,
					[EmptyPropertyLens(), frame.lens...],
					:(Computed(val))
				))
				# TODO Ideally we even render the step here directly,
				# .... so any side-effects on mutable objects will
				# .... show up in time-travel.
				push!($steps_lens, $expr_ref_lens[])
			catch error
				captured_error = CapturedException(
					error,
					stacktrace(catch_backtrace())
				)
				
				$expr_ref_lens[] = $(deepcopy_expr)($expr_ref_lens[])
				$(lens_to_setter(
					expr_ref_lens,
					[EmptyPropertyLens(), frame.lens...],
					:(:(throw($(Computed(error)))))
				))
				push!($steps_lens, $expr_ref_lens[])
				push!($steps_lens, :(throw($(Computed(error)))))

				throw(PartialEvaluatedException(
					expr_with_lens=$(frame),
					steps=$steps_lens,
					error=captured_error,
				))
			end
		end
	end
end

# ╔═╡ 35f63c4e-3583-4ea8-a057-31f18f8a09d6
md"""
## `@skip_as_script`
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

# ╔═╡ cf314b21-3f4f-4637-b1ce-ec1d5d5af966
begin
	if is_inside_pluto(@__MODULE__)
		import Pkg
		Pkg.activate("..")
		Pkg.instantiate()
	end
	import HypertextLiteral: @htl		
end

# ╔═╡ 872b4877-30dd-4a92-a3c8-69eb50675dcb
preish(x) = @htl("<pre-ish>$(x)</pre-ish>")

# ╔═╡ 2f6e353d-2cdc-46d6-9727-01b0a6167ca0
ERROR_ON_UNKNOWN_EXPRESSION_TYPE = is_inside_pluto(@__MODULE__)

# ╔═╡ 22640a2f-ea38-4517-a4f3-7a65e60ffebe
"""
	@displayonly expression

Marks a expression as Pluto-only, which means that it won't be executed when running outside Pluto. Do not use this for your own projects.
"""
macro skip_as_script(ex) is_inside_pluto(__module__) ? esc(ex) : nothing end

# ╔═╡ fd8428a3-9fa3-471a-8b2d-5bbb8fdb3137
@skip_as_script is_good_boy(x) = true;

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

# ╔═╡ 94ebb761-21fb-4015-acb3-26310b19b0dc
@skip_as_script macro return_one()
	return 1
end

# ╔═╡ 586826a5-d667-4035-9796-bd2db61498d6
@skip_as_script macro expand_at_runtime(expr)
	quote
		macroexpand($(__module__), $(QuoteNode(expr)))
	end
end

# ╔═╡ a8fd09d1-c5ca-47f3-8fb3-32d8aeef3e59
@skip_as_script macro return_error(expr)
	quote
		try
			$(esc(expr))
			error("Expected an error")
		catch error
			error
		end
	end
end

# ╔═╡ d414f840-4952-4de5-a565-7fdc81a94817
"The opposite of `@skip_as_script`"
macro only_as_script(ex) is_inside_pluto(__module__) ? nothing : esc(ex) end

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

# ╔═╡ 187c3005-cd43-45a0-8cbd-bc96b9cb39da
Dump(x; maxdepth=8) = sprint(io -> dump(io, x; maxdepth=maxdepth)) |> Text

# ╔═╡ a6709e08-964d-46ea-9813-2c70a834824b
@skip_as_script Dump(ex1)

# ╔═╡ 10803c0d-d0a5-45c5-b7ef-9659e441df69
@skip_as_script Dump(ex2)

# ╔═╡ 411271a6-4236-45e2-ab34-f26410108821
Dump(ex3)

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
@skip_as_script Hannes = let
	url = "https://user-images.githubusercontent.com/6933510/116753174-fa40ab80-aa06-11eb-94d7-88f4171970b2.jpeg"
	data = read(download(url))
	Show(MIME"image/jpg"(), data)
end;

# ╔═╡ 6f5ba692-4b6a-405a-8cd3-1a8f9cc06611
plot(args...; kwargs...) = Hannes

# ╔═╡ 5b70aaf1-9623-4f55-b055-4263ed8be31d
@skip_as_script Floep = let
	url = "https://user-images.githubusercontent.com/6933510/116753861-142ebe00-aa08-11eb-8ce8-684af1098935.jpeg"
	data = read(download(url))
	Show(MIME"image/jpg"(), data)
end;

# ╔═╡ bf2abe01-6ae0-4066-8704-12f64e04511b
@skip_as_script friends = Any[Hannes, Floep];

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
	Expr(
		e.head,
		(
			x isa LineNumberNode ?
			LineNumberNode(0, nothing) :
			remove_linenums(x)
			for x
			in e.args
		)...,
	)
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
	
	lines = split(replace(s, r"#= line 0 =# ?" => ""), "\n")
	
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
	Computed;
	
	printed = sprint() do io
		Base.print(IOContext(io, :module => @__MODULE__), escape_syntax_to_esc_call(move_escape_calls_up(remove_linenums(e))))
	end
	replace(printed, r"#= line 0 =# ?" => "")
end

# ╔═╡ 227129bc-4415-4240-ad55-815bde65a5a1
function Base.showerror(io::IO, error::CantStepifyThisYetException)
	print(io, "CantStepifyThisYetException: Can't make `$(expr_to_str(error.expr))` into separate steps yet")
end

# ╔═╡ ef6fc423-f1b1-4dcb-a059-276121391bc6
prettycolors(e) = Markdown.MD([Markdown.Code("julia", expr_to_str(e))])

# ╔═╡ 0f31dd2e-0331-4d4c-8db5-9ce188cd3730
@skip_as_script [lens_to_getter(:source, [FieldLens(:x), PropertyLens(:y)])] .|> prettycolors

# ╔═╡ cecba3e6-98e8-408a-97dd-96b67c4f42cf
@skip_as_script [lens_to_setter(:dest, [FieldLens(:x), PropertyLens(:y)], :value)] .|> prettycolors

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
		# This was getting closer, but the whole thing still is quite hard...
		# so for now any assignment just throws :D
		# We need quite some smartness in build_step_by_step_blocks.
		throw(CantStepifyThisYetException(e))
		
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
			# @info "III" i arg
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
			throw(CantStepifyThisYetException(e))
		else
			[ExprWithLens(expr=e, lens=[])]
		end
	else
		if ERROR_ON_UNKNOWN_EXPRESSION_TYPE
			throw(CantStepifyThisYetException(e))
		else
			[ExprWithLens(expr=e, lens=[])]
		end
	end
end;

# ╔═╡ e1c306e3-0a47-4149-a9fb-ec7ab380fa11
"""
	step_by_step(expr::Expr)

The preparing for step-by-step testing happens in two steps itself.

First there is [`code_loweredish_with_lenses`](@ref) which takes an expression and splits it up in [`ExprWithLens`](@ref)s. These are separate expressions with a lens specifying where in the original expression the result should be placed.

Second part is combining all those expressions into a block that gradually executes those separate parts, and at each step saves the whole expression to be shown. That's what [`build_step_by_step_blocks`](@ref) is for.

This functions combines these two. This is the main function used inside the test macro. The reason it is a separate function and not a macro on its own, is because macro hygiene is weird... 
"""
function step_by_step(expr)	
	lowered = code_loweredish_with_lenses(expr)
	expr_ref_lens = gensym("expr_ref")
	steps_lens = gensym("steps")
	
	quote
		begin
			try
				expr = $(QuoteNode(expr))
				$steps_lens = Any[expr]
				$expr_ref_lens = Ref{Any}(expr)
				$(build_step_by_step_blocks(lowered;
					expr_ref_lens=expr_ref_lens,
					steps_lens=steps_lens,
				)...)
				$steps_lens
			catch error
				error.steps
			end
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
			else
				WrongCall(expr_raw, steps)
			end
		catch error
			if error isa PartialEvaluatedException
				ErrorCall(
					expr=expr_raw,
					steps=error.steps,
					error=error.error,
				)
			else
				rethrow(error)
			end
		end
	end
end

# ╔═╡ d7dc79e6-1f58-4414-aeef-667bdb0dd200
macro pretty_step_by_step(e)
	quote
		resulting_expressions = try
			$(step_by_step(e))
		catch error
			if error isa PartialEvaluatedException
				error.steps
			else
				rethrow(error)
			end
		end 
		
		resulting_expressions .|> prettycolors
	end
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

# ╔═╡ fc26d26a-a9a5-4646-b85b-12eac66d96cb
example_show_thrown_error = @skip_as_script let
	@pretty_step_by_step sqrt(sqrt(16) - 5)
end

# ╔═╡ 312ef6a6-55aa-4913-9416-15e79b4e3362
example_with_nested_macro = @skip_as_script let
	@pretty_step_by_step @return_one() + 2 == 3
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

# ╔═╡ 60a398c9-9fe8-4b90-b863-1568183641d9
example_returned_function = @skip_as_script let
	function_that_returns_function = () -> function X() 10 end
	@pretty_step_by_step function_that_returns_function()() == 10
end

# ╔═╡ a661e172-6afb-42ff-bd43-bb5b787ee5ed
macro eval_step_by_step(e)
	step_by_step(e)
end

# ╔═╡ b4b317d7-bed1-489c-9650-8d336e330689
rs = @skip_as_script @eval_step_by_step(begin
		(1+2) + (7-6)
		plot(2000 .+ 30 .* rand(2+2))
		4+5
		sqrt(sqrt(sqrt(5)))
	end) .|> SlottedDisplay

# ╔═╡ 93ed973f-daf6-408b-9d4b-d53495418610
@skip_as_script @bind rindex Slider(eachindex(rs))

# ╔═╡ dea898a0-1904-4d09-ad0b-6915008fe946
@skip_as_script rs[rindex]

# ╔═╡ b0ab9327-8240-4d34-bdd9-3f8f5117bb29
struct PlutoStylesheet
	code
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
	color: rgba(0, 0, 0, 0.5);
}

@media (prefers-color-scheme: dark) {
	
	.pluto-test.pass {
		color: rgba(200, 200, 200, 0.5);
	}

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

# ╔═╡ e968fc57-d850-4e2d-9410-8777d03b7b3c
function frames(fs::Vector, startframe = nothing)
	l = length(fs)
	
	startframe = if isnothing(startframe)
		l > 2 ? l - 1 : l
	else
		startframe
	end
	
	@htl("""<p-frame-viewer>
		<p-frames>
		$(fs)
		</p-frames>
		
		<p-frame-controls>
			<img src="https://cdn.jsdelivr.net/gh/ionic-team/ionicons@5.5.1/src/svg/time-outline.svg" style="width: 1em; height: 1em; transform: scale(-1,1); opacity: .5; margin-left: 2em;">
			<input class="timescrub" style="filter: hue-rotate(149deg) grayscale(.9);" type=range min=1 max=$(l) value=$(startframe)>
		</p-frame-controls>
		
		
		<script>
		const div = currentScript.parentElement
		
		const input = div.querySelector(":scope > p-frame-controls > input.timescrub")
		const frames = div.querySelector(":scope > p-frames")
		
		const setviz = () => {
			Array.from(frames.children).forEach((f,i) => {
				f.style.display = i + 1 === input.valueAsNumber ? "inherit" : "none"
			})
		}
		
		setviz()
		
		input.addEventListener("input", setviz)
		</script>
	
		<style>
		$(frames_css)
		</style>
	</p-frame-viewer>""")
end

# ╔═╡ 74c19786-1ba7-4865-a993-590a779ae564
@skip_as_script frames(rs)

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

# ╔═╡ b273d3d3-648f-4d34-94e7-e49277d4ba29
with_slotted_css(x) = @htl("""
	$(x)
	<style>
	$(slotted_code_css)
	</style>
	""")

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
@skip_as_script @visual_debug begin
	(1+2) + (7-6)
	plot(2000 .+ 30 .* rand(2+2))
	4+5
	sqrt(sqrt(sqrt(5)))
	md"#### Wow"
end

# ╔═╡ 1e619ca9-e00f-46d0-b327-85b33929787f
function Base.show(io::IO, mime::MIME"text/html", stylesheet::PlutoStylesheet)
	# show(io, mime, md"`<style>...`")
	print(io, "Stylesheet")
end

# ╔═╡ 9c3f6eab-b1c3-4607-add8-d6d7e468c11a
begin
	show_for_test_result_should_be_defined_before_test_macro = true
	
	function Base.show(io::IO, m::MIME"text/html", call::Union{WrongCall,CorrectCall,ErrorCall})
		

		infix = if Meta.isexpr(call.expr, :call)
			fname = call.expr.args[1]
			if fname isa Symbol
				Meta.isbinaryoperator(fname)
			else
				false
			end
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

	md"""
	```julia
	function Base.show(io::IO, m::MIME"text/html", call::Union{WrongCall,CorrectCall,ErrorCall})
	```
	"""
end

# ╔═╡ a4a067b5-8b4b-4846-b986-0417d83cba48
macro test(main_expr, expr...)
	show_for_test_result_should_be_defined_before_test_macro
	
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

# ╔═╡ 73d74146-8f60-4388-aaba-0dfe4215cb5d
@skip_as_script @test sqrt(20-11) == 3

# ╔═╡ 71b22e76-2b50-4d16-85f6-9dad0415630e
@skip_as_script @test iseven(123 + 7^3)

# ╔═╡ 6762ed72-f422-43a9-a782-de78f739c0ae
@skip_as_script @test 4+4 ∈ [1:7...]

# ╔═╡ f77275b9-90aa-4e07-a608-981b5df727af
@skip_as_script @test is_good_boy(first(friends))

# ╔═╡ 37529063-8ee9-46a6-85cc-94db292da541
@skip_as_script @test sqrt(sqrt(16)) == sqrt(2)

# ╔═╡ 89f78031-1c54-468b-9ab8-7410c51df10e
export @test

# ╔═╡ 97eb4444-a22c-47f2-9247-3bce6d7e179e
example_longer_fn_name =  @skip_as_script begin
	@test Test.Pass(:symbol, 10, 10, 10) isa Test.Pass
end

# ╔═╡ 24f2eb92-5fd7-429b-b2ea-a987195c6edb
example_cant_stepify_assignments = @skip_as_script let
	@test @return_error(begin
		@expand_at_runtime @test begin
			x = 1 + 3
			x
		end
	end).error isa CantStepifyThisYetException
end

# ╔═╡ bedc3586-6b85-4de2-9ea1-79d842db6b56
example_cant_stepify_try_catch = @skip_as_script let
	@test @return_error(begin
		@expand_at_runtime @test try
			0 / 0
		catch error
			"Oops"
		end
	end).error isa CantStepifyThisYetException
end

# ╔═╡ 42f34453-9935-4e50-a62b-9dcf31d72601
example_cant_stepify_if_else = @skip_as_script let
	@test @return_error(begin
		@expand_at_runtime @test if 4 > 5
			"Yeahhh"
		else
			"Nohhhh"
		end
	end).error isa CantStepifyThisYetException
end

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
# ╠═89f78031-1c54-468b-9ab8-7410c51df10e
# ╠═cf314b21-3f4f-4637-b1ce-ec1d5d5af966
# ╠═78704300-0531-4f8e-8aa5-3f588fbdd190
# ╠═9129342b-f560-4901-81a2-56e3f8641521
# ╠═c763ed72-82c9-445c-a8f7-a0c40982e4d9
# ╠═8a2e8348-49cf-4855-b5b3-cdee33e5ed67
# ╟─42671258-07a0-4015-8f47-4b3032595f08
# ╟─0d70962a-3880-4dee-a439-35068d019f5a
# ╠═113cc425-e224-4f77-bfbd-ef4eb1d1ed70
# ╠═6188f559-bcab-4da6-84b2-a3fe522a5c3c
# ╠═c24b46ce-bcbb-4dc9-8a59-b5b1bd2cd617
# ╠═5041085e-a406-4ed4-ab82-84d8f126cf0f
# ╠═03ccd498-83c3-41bb-84d7-625adabd7aee
# ╠═1bcf8bd1-c8a3-49a1-9791-d813aa856399
# ╠═14c525a1-eca1-466b-8e63-3a90d7d7111c
# ╟─a2efc968-246c-40c2-b285-2ec94b185a44
# ╟─e1c306e3-0a47-4149-a9fb-ec7ab380fa11
# ╠═b6e8a170-12cc-4d97-905d-274e2609bfd8
# ╠═a4a067b5-8b4b-4846-b986-0417d83cba48
# ╟─9c3f6eab-b1c3-4607-add8-d6d7e468c11a
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
# ╟─a392d2d6-5a16-4383-b0ef-5003aa2de9fa
# ╟─ae95b691-f54b-4bf5-b17b-3e5bd1edf75e
# ╟─12119016-fa61-4d38-8c58-821ea435df7d
# ╠═9bed78b6-5a8f-44ce-ab66-cab685daf264
# ╟─74929fa6-d1f7-41cd-ab55-48f35d5fbf28
# ╟─f1ede628-d158-4296-befd-3eaa87cdad27
# ╠═2f6e353d-2cdc-46d6-9727-01b0a6167ca0
# ╠═17dea9e5-84ea-4476-a318-cc475043c83b
# ╟─5e66e59b-fdb8-4373-b231-097b0227dc5c
# ╠═c47252b9-8869-4878-b9bf-7eeb7ed17c9a
# ╟─227129bc-4415-4240-ad55-815bde65a5a1
# ╠═ce90612e-ffc1-4e30-9d89-531f11fd75eb
# ╟─0a3f5c6c-6e1b-458c-bf91-523a0b639b41
# ╟─43fe89d7-f33e-4dfa-853e-327e981feb1e
# ╟─fc000550-3053-483e-bc41-6aed22c3999c
# ╟─3f11ca4c-dd06-47c9-92e2-cb97c18a06db
# ╟─b155d336-f746-4c82-8206-ab1a49cedea8
# ╟─f9b2a11d-8c4e-47a5-9d93-38025fae9a95
# ╟─221aa13b-aa25-4145-8076-da77432364bb
# ╟─2a514f2f-79c8-4b0d-be8a-170f3386d5d5
# ╟─9fb4d52d-77f2-4032-a769-6d5e60be43bf
# ╟─1c1b64b1-107e-4d43-9ce2-569c3034017e
# ╟─cade56ad-312e-40cf-bcda-11480ce27852
# ╟─810470b8-0a6c-48b8-aba2-a2058b8d9f59
# ╟─a29d5277-e97a-4cca-8e31-8037f9cfdd80
# ╟─4f7aac13-9e49-4b2b-8d78-53f583f6130a
# ╟─cc7102e1-6af0-43bb-8cf0-43e2cec210e3
# ╠═f5d9a4c5-300f-4dae-8507-346ec0b74632
# ╟─ec6f1b07-d026-45ca-996d-be7693664cd7
# ╟─dadf1c50-6588-4345-a240-69a72336c7cd
# ╟─d384e3fc-b207-48ce-bc7b-1b47a14b1581
# ╟─d7dc79e6-1f58-4414-aeef-667bdb0dd200
# ╟─a661e172-6afb-42ff-bd43-bb5b787ee5ed
# ╟─a6e8c835-f209-445a-9f43-cdf2ecfd1b57
# ╟─5759b2cc-1e96-4069-ae42-bc159c7cf5fb
# ╟─ba4a5762-33da-40e6-94fa-cca9befc6d5a
# ╟─9101631b-81ca-4c7c-94da-81d9e106df78
# ╟─3f0e5a49-5eec-42cd-bd2c-254b277840bf
# ╟─fc26d26a-a9a5-4646-b85b-12eac66d96cb
# ╟─94ebb761-21fb-4015-acb3-26310b19b0dc
# ╟─312ef6a6-55aa-4913-9416-15e79b4e3362
# ╠═97eb4444-a22c-47f2-9247-3bce6d7e179e
# ╟─716d9ddc-18dc-4973-924e-e5ebf9161ff6
# ╟─1aa319c8-5e1d-4dd9-ae22-ad99e46e7b4d
# ╟─605d2481-23be-4ad9-82c9-e375b7be8669
# ╟─bc08755d-721f-403e-af95-36494b8fb7bc
# ╟─586826a5-d667-4035-9796-bd2db61498d6
# ╟─a8fd09d1-c5ca-47f3-8fb3-32d8aeef3e59
# ╟─24f2eb92-5fd7-429b-b2ea-a987195c6edb
# ╠═bedc3586-6b85-4de2-9ea1-79d842db6b56
# ╠═42f34453-9935-4e50-a62b-9dcf31d72601
# ╟─de94f2b5-96ae-4936-870f-7639a39fd40d
# ╟─60a398c9-9fe8-4b90-b863-1568183641d9
# ╟─21d4560e-721f-4ed4-9db7-86a8151ab22c
# ╟─99afc7f4-727c-4277-8311-f2ffa94830ae
# ╟─4956526a-daf9-43c9-bff3-ff2446016e2e
# ╟─84ff6a23-c134-4910-b630-a7ad45f3bf29
# ╟─318363d0-6d9e-4144-b478-b775f437edaf
# ╟─67fd07b7-340b-4e24-bc06-e4c85b186872
# ╟─c6d5597c-d505-4125-88c4-10415934d2a4
# ╟─872b4877-30dd-4a92-a3c8-69eb50675dcb
# ╟─c877c109-db16-468c-8f3c-8294db859d6d
# ╟─ab0a19b8-cf7c-4c4f-802a-f85eef81fc02
# ╟─8480d0d7-bdf7-468d-9344-5b789e33921c
# ╠═6f5ba692-4b6a-405a-8cd3-1a8f9cc06611
# ╟─b4b317d7-bed1-489c-9650-8d336e330689
# ╠═93ed973f-daf6-408b-9d4b-d53495418610
# ╠═dea898a0-1904-4d09-ad0b-6915008fe946
# ╟─b5763c10-e11c-4389-b6fc-421d2c9682f1
# ╟─74c19786-1ba7-4865-a993-590a779ae564
# ╠═e968fc57-d850-4e2d-9410-8777d03b7b3c
# ╟─3d5abd58-02ab-4b91-a7a3-d9068d4df017
# ╟─326f7661-3482-4bf2-a97b-57cc7ac60ee2
# ╟─b273d3d3-648f-4d34-94e7-e49277d4ba29
# ╠═a2cbb0c3-23b9-4091-9ca7-5ba96e85e3a3
# ╟─f9ed2487-a7f6-4ce9-b673-f8a298cd5fc3
# ╟─20166ec9-7084-4d58-8b19-3aa51cc8f2c6
# ╟─0f31dd2e-0331-4d4c-8db5-9ce188cd3730
# ╟─cecba3e6-98e8-408a-97dd-96b67c4f42cf
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
# ╟─22640a2f-ea38-4517-a4f3-7a65e60ffebe
# ╟─d414f840-4952-4de5-a565-7fdc81a94817
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
# ╠═4d5f44e4-85e9-4985-9b76-73be5e097186
# ╟─dd495e00-d74d-47d4-a5d5-422fb147ec3b
# ╟─7e6c2162-97e9-4835-b650-52c9723c327f
# ╠═1ac164c8-88fc-4a87-a194-60ef616fb399
# ╠═b0ab9327-8240-4d34-bdd9-3f8f5117bb29
# ╟─1e619ca9-e00f-46d0-b327-85b33929787f
