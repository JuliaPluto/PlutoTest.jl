### A Pluto.jl notebook ###
# v0.16.1

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
> # PlutoTest.jl
> 
> _Visual, reactive testing library for Julia_

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

# ╔═╡ 80b2fb3f-94b2-4024-94ff-d111a249c8b0


# ╔═╡ 9d49ea50-8158-4d8b-97af-edba1f7dc38b
x = [1,3]

# ╔═╡ 1aa24b1c-e8ca-4de7-b614-7a3f02b4833d
# Fons wtf
always_false(args...; kwargs...) = true

# ╔═╡ 8a2e8348-49cf-4855-b5b3-cdee33e5ed67
const pluto_test_css = """
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
""";

# ╔═╡ 42671258-07a0-4015-8f47-4b3032595f08
const frames_css = """
p-frame-viewer {
	display: inline-flex;
	flex-direction: column;
}
p-frames,
p-frame-controls {
	display: inline-flex;
}
""";

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

# ╔═╡ 4bc1b7a4-0a36-4a07-b7ee-3d5be50350e1
("asd"*"asd","asd","asd"*" asd","asd","asd"*"asd","asd","asd"*"asd","asd","asd"*"asd","asd","asd"*"asd","asd","asd"*"asd","asd")

# ╔═╡ 3b2e8f55-1d4b-4a36-83f6-26becbd79e4b
# @test (@test t isa Pass) isa Pass

# ╔═╡ ec2ed42c-1227-4e0d-b642-20e6f3503d2a
embed_display(x) = if isdefined(Main, :PlutoRunner) && isdefined(Main.PlutoRunner, :embed_display)
	# if this package is used inside Pluto, and Pluto is new enough
	Main.PlutoRunner.embed_display(x)
else
	identity(x)
end

# ╔═╡ 1ac164c8-88fc-4a87-a194-60ef616fb399
flatmap(args...) = vcat(map(args...)...)

# ╔═╡ 98ac4c36-49c7-4f65-982d-0b8bf6c372c0
emb = embed_display

# ╔═╡ a83a6a4c-664c-46fa-a07f-81088493dc35
const ObjectID = typeof(objectid("hello computer"))


# ╔═╡ 5cb03161-2cbc-4080-ba59-f94efd3b620c
expr_hash(e::Expr) = objectid(e.head) + mapreduce(p -> objectid((p[1], expr_hash(p[2]))), +, enumerate(e.args); init=zero(ObjectID))

# ╔═╡ 0611a36b-b4be-4b17-a485-7c4a8fa04927
expr_hash(x) = objectid(x)

# ╔═╡ dbfbcc16-c740-436c-bbf0-fee16b0a20c5
md"""
# $(html"<img src='https://cdn.jsdelivr.net/gh/ionic-team/ionicons@5.5.1/src/svg/time-outline.svg' style='height: .75em; margin-bottom: -.1em'>") _Time travel_ evaluation

In Julia, expressions are objects! This means that, before evaluation, code is expressed as a Julia object:
"""

# ╔═╡ d97987a0-bdc0-46ed-a6a5-f35c1ce961dc
ex1 = :(first([56,sqrt(9)]))

# ╔═╡ 7c2bab29-8609-4575-b2ca-7feb34915645
md"""
You can use `Core.eval` to evaluate expressions at runtime:
"""

# ╔═╡ 838b5904-1de2-4d9f-8f3c-a93ec224d40e
md"""
But _did you know_ that you can also **partially evaluate** expressions? 
"""

# ╔═╡ a3c41025-2f4a-4f9c-8577-72e4b7abbb98
ex2_inner = ex1.args[2]

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

# ╔═╡ 302c1fab-a358-4a5f-a3fb-4f26a17df4f6


# ╔═╡ 7db64b02-8f64-4146-bf77-ef94cb45aae0
function increase_counter(x, ref)
	ref[] = ref[] + 1
	return x
end

# ╔═╡ 83517988-08da-4031-8d51-50d79b48b73a


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

# ╔═╡ 0f31dd2e-0331-4d4c-8db5-9ce188cd3730
lens_to_getter(nothing, [PropertyLens(:x), PropertyLens(:y)])

# ╔═╡ 828e089e-64be-47c5-8e3c-7107adf02367
lens_to_setter(Dict(:y => 1), [PropertyLens(:x)], 2)

# ╔═╡ 5e66e59b-fdb8-4373-b231-097b0227dc5c
Base.@kwdef struct CodeFrameWithExpr
	expr
	lens
end

# ╔═╡ f5d9a4c5-300f-4dae-8507-346ec0b74632
function expand_lowered_to_expr(
	lowered::Vector{CodeFrameWithExpr};
	expr_ref
)
	map(lowered) do frame
		# This whoooooole thing is to not execute parts of the code multiple times.
		# It replaces, when possible, the arguments in the expression with a reference
		# to the argument in the latest version of the expression
		# (where some nodes are Computed, which we will use)
		frame_lens = lens_to_getter(expr_ref, [
			EmptyPropertyLens(),
			frame.lens...,
		])
		expr_with_arguments_as_references = if Meta.isexpr(frame.expr, :macrocall)
			esc(frame.expr)
		elseif frame.expr isa Expr
			Expr(
				frame.expr.head,
				map(enumerate(frame.expr.args)) do (i, arg)
					arg_lens = :($(frame_lens).args[$(i)])
					if Meta.isexpr(arg, :...)
						:((
							$(arg_lens).args[1] isa Computed ?
							$(arg_lens).args[1].x :
							$(esc(arg.args[1]))
						)...)
					elseif Meta.isexpr(arg, :call)
						:($(arg_lens) isa Computed ? $(arg_lens).x : $(esc(arg)))
					else
						esc(arg)
					end
				end...
			)
		else
			esc(frame.expr)
		end

		quote
			# asdasdsada
			val = $(expr_with_arguments_as_references)
			$expr_ref[] = deepcopy($expr_ref[])
			$(lens_to_setter(
				expr_ref,
				[EmptyPropertyLens(), frame.lens...],
				:(Computed(val))
			))
			push!(steps, $expr_ref[])
		end
	end
end

# ╔═╡ af787ecf-b54e-4519-801d-eee323a1a2a3
function lowered_with_reference_to_expr(x)
	[CodeFrameWithExpr(expr=x, lens=[])]
end

# ╔═╡ bd1d1541-134d-4c88-bb41-920ac36bfe92
function lowered_with_reference_to_expr(e::Expr)::Vector{CodeFrameWithExpr}
	if e.head === :call || e.head === :begin || e.head === :block# || e.head === :vect
		argument_frames = flatmap(enumerate(e.args)) do (i, arg)
			
			if arg isa QuoteNode
				[]
				
			elseif (Meta.isexpr(e, :call) || Meta.isexpr(e, :let)) && i == 1
				[]
				
			elseif arg isa Symbol
				[CodeFrameWithExpr(
						expr=arg,
						lens=[FieldLens(:args), PropertyLens(i)],
				)]
				
			elseif arg isa Expr
				frames = lowered_with_reference_to_expr(arg)
				map(frames) do frame
					CodeFrameWithExpr(
						expr=frame.expr,
						lens=[FieldLens(:args), PropertyLens(i), frame.lens...]
					)
				end
			else
				[]
			end
		end
		
		[
			argument_frames...,
			CodeFrameWithExpr(
				expr=e,
				lens=[]
			)
		]
	else
		[
			CodeFrameWithExpr(
				expr=e,
				lens=[]
			)
		]
	end
end

# ╔═╡ bed3d31a-356a-4f9e-9a58-38b511f2b0e7
lowered_sqrt = lowered_with_reference_to_expr(:(sqrt(sqrt(4)) == 2))

# ╔═╡ b4e5b2a0-1ccb-4e10-bd5d-a26916568d69
xxx = lowered_with_reference_to_expr(quote
	sqrt(sqrt(4)) == 2
end)

# ╔═╡ ceb2c456-de9b-40a7-ac9f-3ba8d8708c2f
lowered_with_reference_to_expr(:(4+4 ∈ [1:7...]))

# ╔═╡ 88f6a040-07cf-47e0-a8be-2478ea350aa7
can_interpret(x) = true

# ╔═╡ d36a8a72-eced-4e63-9130-7fcb6c86df76
can_interpret_call_arg(e::Expr) = !(e.head === :(...) || e.head === :kw || e.head === :parameters)

# ╔═╡ e9659020-d433-4357-9099-71a65b66a091
can_interpret_call_arg(x) = true

# ╔═╡ c3fc3292-b7eb-4b01-8fba-159c86228de9
Meta.isbinaryoperator(:(==))

# ╔═╡ 89578bff-16b9-4eb2-b8ee-b2839ff2d74c
can_interpret(e::Expr) = if false
	false
elseif e.head === :call && !all(can_interpret_call_arg, e.args)
	false
# elseif e.head === :(=) || e.head === :macrocall
# 	false
else
	all(can_interpret, e.args)
end

# ╔═╡ e1c306e3-0a47-4149-a9fb-ec7ab380fa11
function step_by_step(expr)
	Computed
	expand_lowered_to_expr
	
	if can_interpret(expr)
		lowered = lowered_with_reference_to_expr(expr)
		
		expr_ref = gensym("expr_ref")
		quote
			begin
				expr = $(QuoteNode(expr))
				steps = Any[expr]
				$expr_ref = Ref{Any}(expr)
				$(expand_lowered_to_expr(lowered; expr_ref=expr_ref)...)
				steps
			end
		end
	else
		quote
			[$(QuoteNode(expr)), Computed($(esc(expr)))]
		end
	end
end

# ╔═╡ a661e172-6afb-42ff-bd43-bb5b787ee5ed
macro eval_step_by_step(e)
	step_by_step(e)
end

# ╔═╡ fe02352b-962a-4ac5-ba40-6b96112235ee
@eval_step_by_step 1 + 1

# ╔═╡ 68ba60db-44ad-43e4-b33e-d27696babc99
@eval_step_by_step sqrt(sqrt(length([1,2])))

# ╔═╡ 807bcd72-26c3-44d3-a295-56874cb51a89
@eval_step_by_step xasdf = 123

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
#### SlottedDisplay

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
const slotted_code_css = """
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
"""

# ╔═╡ b4b317d7-bed1-489c-9650-8d336e330689
rs = @eval_step_by_step(begin
		(1+2) + (7-6)
		plot(2000 .+ 30 .* rand(2+2))
		4+5
		sqrt(sqrt(sqrt(5)))
	end) .|> SlottedDisplay

# ╔═╡ b5763c10-e11c-4389-b6fc-421d2c9682f1
md"""
#### Frame viewer

A widget that takes a series of elements and displays them as 'video frames' with a timeline scrubber.
"""

# ╔═╡ 3d5abd58-02ab-4b91-a7a3-d9068d4df017
md"""
#### Macro to test frames
"""

# ╔═╡ 34f613a3-85fb-45a8-be3b-cd8e6b3cb5a2


# ╔═╡ f9ed2487-a7f6-4ce9-b673-f8a298cd5fc3
md"""
# Appendix
"""

# ╔═╡ c55ae954-2d1e-4633-91e6-2c303ae40334


# ╔═╡ 4d5f44e4-85e9-4985-9b76-73be5e097186
remove_linenums(e::Expr) = if e.head === :macrocall
	Expr(e.head, (remove_linenums(x) for x in e.args)...)
else
	Expr(e.head, (remove_linenums(x) for x in e.args if !(x isa LineNumberNode))...)
end

# ╔═╡ dd495e00-d74d-47d4-a5d5-422fb147ec3b
remove_linenums(x) = x

# ╔═╡ b765dbfe-4e58-4bb9-b1d6-aa4378d4e9c9
expr_to_str(e, mod=@__MODULE__()) = let
	Computed
	sprint() do io
		Base.print(IOContext(io, :module => @__MODULE__), remove_linenums(e))
	end
end

# ╔═╡ ea73a35e-a34f-4708-acc1-858f2466e9ba
expr_to_str(:(x+1))

# ╔═╡ ef6fc423-f1b1-4dcb-a059-276121391bc6
prettycolors(e) = Markdown.MD([Markdown.Code("julia", expr_to_str(e))])

# ╔═╡ 3fccae0c-ab69-4bc8-858b-ede886c45e32
(@eval_step_by_step begin sqrt(sqrt(4)) + 2 end) .|> prettycolors

# ╔═╡ c46d5246-e62f-4f2e-9e3a-0608c8c48b2e
(@eval_step_by_step begin 4+4 ∈ [1:7...] end) .|> prettycolors

# ╔═╡ 7dc21aa9-252f-4654-95c8-fe297f0d6021
expand_lowered_to_expr(lowered_with_reference_to_expr(:([1:7...])); expr_ref=:expr_ref) .|> prettycolors

# ╔═╡ 03579ca6-d04b-4ba7-829c-8cf3c3fdbafa
expand_lowered_to_expr(lowered_with_reference_to_expr(:(sqrt(sqrt(1)))); expr_ref=:expr_ref) .|> prettycolors

# ╔═╡ d2e1d5ae-2daa-4cf1-8cd9-68bb8c6c81a1
let
	executed_count = Ref(0)
	steps = @eval_step_by_step(begin sqrt(sqrt(increase_counter(16, executed_count))) end) .|> prettycolors
	
	(executed_count=executed_count, steps=steps)
end

# ╔═╡ 3650d813-8a6c-4cd0-bb68-8b384e8211d8
expand_lowered_to_expr(lowered_with_reference_to_expr(quote
	@test 1 + 1
end); expr_ref=:expr_ref) .|> prettycolors

# ╔═╡ 907543c6-b7ed-4521-af21-d6fb86ce4518
expand_lowered_to_expr(lowered_sqrt; expr_ref=:expr_ref) .|> prettycolors

# ╔═╡ 0a7a0d9e-034f-4f36-a57c-34b5d4ca896d
expand_lowered_to_expr(xxx; expr_ref=:expr_ref) .|> prettycolors

# ╔═╡ ba28d507-816f-45c0-b6c0-2f5f4f09855f
(@eval_step_by_step begin sqrt(sqrt(4)) == 2 end) .|> prettycolors

# ╔═╡ 930f8244-cf25-4c1a-95f6-5c8963559c62
@macroexpand(@eval_step_by_step x == [1,2]) |> prettycolors

# ╔═╡ 35f63c4e-3583-4ea8-a057-31f18f8a09d6
md"""
## DisplayOnly
"""

# ╔═╡ 35b2770e-1db6-4327-bf86-c27a4b61dbd3
function is_inside_pluto(m::Module)::Bool
	if isdefined(m, :PlutoForceDisplay)
		return m.PlutoForceDisplay
	else
		isdefined(m, :PlutoRunner) && parentmodule(m) === Main
	end
end

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
	import Test
end

# ╔═╡ 05f42764-acfe-4370-b85b-ce0e7c4270d0
begin
	export @test_nowarn, @test_warn, @test_logs, @test_skip, @test_broken, @test_throws, @test_deprecated
	
	var"@test_warn" = Test.var"@test_warn"
	var"@test_nowarn" = Test.var"@test_nowarn"
	var"@test_logs" = Test.var"@test_logs"
	var"@test_skip" = Test.var"@test_skip"
	var"@test_broken" = Test.var"@test_broken"
	var"@test_throws" = Test.var"@test_throws"
	var"@test_deprecated" = Test.var"@test_deprecated"
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
			rethrow(e)
			# Error(expr_raw, e)
		end
	end
end

# ╔═╡ 872b4877-30dd-4a92-a3c8-69eb50675dcb
preish(x) = @htl("<pre-ish>$(x)</pre-ish>")

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

# ╔═╡ 74c19786-1ba7-4865-a993-590a779ae564
frames(rs)

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
@visual_debug begin
	(1+2) + (7-6)
	plot(2000 .+ 30 .* rand(2+2))
	4+5
	sqrt(sqrt(sqrt(5)))
	md"# Wow"
end

# ╔═╡ 69bfb438-7ecf-4f9b-8bc4-51e07aa46ef1
@skip_as_script Core.eval(Module(), ex1)

# ╔═╡ 3e79ff61-6532-4879-9402-86473aa7d960
ex2_inner_result = @skip_as_script Core.eval(Module(), ex2_inner)

# ╔═╡ 275c5f57-623d-439f-b09d-f7c745e0bed6
ex2 = Expr(:call, :first, ex2_inner_result)

# ╔═╡ 38e54516-cdf4-4c1d-815b-68e1e7a7f6f7
ex3 = Expr(:call, :first, Computed(ex2_inner_result))

# ╔═╡ 9bed78b6-5a8f-44ce-ab66-cab685daf264
unwrap_computed(ex3)

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
toc()

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

# ╔═╡ 93ed973f-daf6-408b-9d4b-d53495418610
@bind rindex Slider(eachindex(rs))

# ╔═╡ dea898a0-1904-4d09-ad0b-6915008fe946
rs[rindex]

# ╔═╡ 187c3005-cd43-45a0-8cbd-bc96b9cb39da
Dump(x; maxdepth=8) = sprint(io -> dump(io, x; maxdepth=maxdepth)) |> Text

# ╔═╡ a6709e08-964d-46ea-9813-2c70a834824b
Dump(ex1)

# ╔═╡ 10803c0d-d0a5-45c5-b7ef-9659e441df69
Dump(ex2)

# ╔═╡ 411271a6-4236-45e2-ab34-f26410108821
Dump(ex3)

# ╔═╡ daee414b-3e3c-4e2a-a25a-429a1e7275d5
Dump(Ref(1))

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

# ╔═╡ 9c3f6eab-b1c3-4607-add8-d6d7e468c11a
begin
	export @test
	
	macro test(expr...)
		test(expr...)
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
		
			$(frames(SlottedDisplay.(call.steps)))
		</div>
		<style>
		$(pluto_test_css)
		$(slotted_code_css)
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

# ╔═╡ 1872f785-1ae5-43ea-bce1-6c5cd893f3a8
@test !!always_false(rand(2), rand(2),123; r=123)

# ╔═╡ 5570972e-9309-4458-99a6-ea718ec2c3ab
@test always_false([1,2,3]...)

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

# ╔═╡ 3a6a6ee1-c619-4044-b9b1-68e5ae9d2463
map(1:10) do i
	@test sqrt(i) < 3 && always_false()
end

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

# ╔═╡ ac02b12a-3982-4526-a51c-0bf85198b81b
var"@test"; macroexpand(@__MODULE__, :(@test x == [1,2+i]); recursive=false) |> prettycolors

# ╔═╡ bb770f3f-72dd-4a71-8d71-9e773224df05
t = @test always_false(rand(20), rand(20),123)

# ╔═╡ 22a33c8c-e07f-445e-9d8d-a676f704ec45
@test begin
	(1+2) - (3+4)
	false
end

# ╔═╡ 176f39f1-fa36-4ce1-86ba-76248848a834
@test (@test always_false(rand(30),123)) isa Fail

# ╔═╡ 8150cb7e-b2e2-4ee8-a475-db4454c954f0
embed_display(@test false)

# ╔═╡ d9b35d00-64c7-472c-8890-8db5efc487b1
@test error("Wow")

# ╔═╡ 716bba60-bfbb-48a4-8924-8bf4e8958cb1
@test always_false("asd"*"asd","asd","asd"*" asd","asd","asd"*"asd","asd","asd"*"asd","asd","asd"*"asd","asd","asd"*"asd","asd","asd"*"asd","asd")

# ╔═╡ 7c1aa057-dff2-48cd-aad5-1bbc1c0a729b
@test π ≈ 3.14 atol=0.01 rtol=1

# ╔═╡ 9741e0d3-d61d-48f4-a80d-b8b24e896190
@test [1, sqrt(sqrt(2)), 8^7]

# ╔═╡ 17f0b235-bf0f-4ace-aaf1-ef3e5d325aad
let
	asd12 = 10
	@test asd12 == 10
end

# ╔═╡ de62537b-a428-48d3-a866-151127b3255b


# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
Pkg = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
Test = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[compat]
HypertextLiteral = "~0.9.0"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

[[ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[HypertextLiteral]]
git-tree-sha1 = "72053798e1be56026b81d4e2682dbe58922e5ec9"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.0"

[[InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"

[[LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"

[[LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"

[[Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

[[MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[Random]]
deps = ["Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

[[Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"

[[Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"

[[nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"

[[p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
"""

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
# ╠═80b2fb3f-94b2-4024-94ff-d111a249c8b0
# ╠═c763ed72-82c9-445c-a8f7-a0c40982e4d9
# ╠═9d49ea50-8158-4d8b-97af-edba1f7dc38b
# ╠═eab4ba31-c787-46dd-8024-693eca7fd1a0
# ╠═26b0faf0-9016-48d7-8667-c1c1cfce655e
# ╠═26b4fb86-892f-415c-8046-6a5449052fd7
# ╠═96dc7b01-3766-4206-88ba-eca1665bc5cb
# ╠═7c6ce205-053d-434c-b5b1-500babb8ec02
# ╠═a6f82260-3519-4254-a21e-abc7bb19ec4e
# ╠═fe7f8cce-a706-476d-8680-a2fe793b474f
# ╠═1872f785-1ae5-43ea-bce1-6c5cd893f3a8
# ╠═5570972e-9309-4458-99a6-ea718ec2c3ab
# ╠═8d340983-ea07-4038-872f-22a165003ed2
# ╠═ea5a4fc0-db62-41dd-9600-a21d4eabf822
# ╠═c369b4b5-2fcf-4029-a1f6-352120b2fc4b
# ╠═4509cdbf-8b8b-4f70-9e63-bb972eb88c93
# ╠═98992db9-4f14-4aa6-a7c5-477622266112
# ╠═8360d1bc-b1f4-4263-a042-724cbd120227
# ╠═064e28de-0c22-48b5-b427-6eb343880287
# ╠═3a6a6ee1-c619-4044-b9b1-68e5ae9d2463
# ╠═be93a6f4-b626-43db-a2fe-4e754e79c030
# ╠═e9370ce7-24ff-475a-ae47-c1de3eaeac7a
# ╟─17bd5cd9-212f-4656-ab79-590dd6c64ff8
# ╟─539e2c38-993b-4b3b-8aa0-f02d46d79839
# ╟─3d3f3592-e056-4e7b-8896-a75e5b5dcad6
# ╠═1aa24b1c-e8ca-4de7-b614-7a3f02b4833d
# ╠═8a2e8348-49cf-4855-b5b3-cdee33e5ed67
# ╠═42671258-07a0-4015-8f47-4b3032595f08
# ╠═05f42764-acfe-4370-b85b-ce0e7c4270d0
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
# ╠═ac02b12a-3982-4526-a51c-0bf85198b81b
# ╠═bb770f3f-72dd-4a71-8d71-9e773224df05
# ╠═22a33c8c-e07f-445e-9d8d-a676f704ec45
# ╠═176f39f1-fa36-4ce1-86ba-76248848a834
# ╠═8150cb7e-b2e2-4ee8-a475-db4454c954f0
# ╠═d9b35d00-64c7-472c-8890-8db5efc487b1
# ╠═716bba60-bfbb-48a4-8924-8bf4e8958cb1
# ╠═4bc1b7a4-0a36-4a07-b7ee-3d5be50350e1
# ╠═3b2e8f55-1d4b-4a36-83f6-26becbd79e4b
# ╠═7c1aa057-dff2-48cd-aad5-1bbc1c0a729b
# ╠═ec2ed42c-1227-4e0d-b642-20e6f3503d2a
# ╠═9741e0d3-d61d-48f4-a80d-b8b24e896190
# ╠═9c3f6eab-b1c3-4607-add8-d6d7e468c11a
# ╠═1ac164c8-88fc-4a87-a194-60ef616fb399
# ╠═98ac4c36-49c7-4f65-982d-0b8bf6c372c0
# ╠═ea73a35e-a34f-4708-acc1-858f2466e9ba
# ╟─a83a6a4c-664c-46fa-a07f-81088493dc35
# ╟─5cb03161-2cbc-4080-ba59-f94efd3b620c
# ╟─0611a36b-b4be-4b17-a485-7c4a8fa04927
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
# ╠═7dc21aa9-252f-4654-95c8-fe297f0d6021
# ╠═03579ca6-d04b-4ba7-829c-8cf3c3fdbafa
# ╠═302c1fab-a358-4a5f-a3fb-4f26a17df4f6
# ╟─7db64b02-8f64-4146-bf77-ef94cb45aae0
# ╠═d2e1d5ae-2daa-4cf1-8cd9-68bb8c6c81a1
# ╠═83517988-08da-4031-8d51-50d79b48b73a
# ╠═3650d813-8a6c-4cd0-bb68-8b384e8211d8
# ╠═f5d9a4c5-300f-4dae-8507-346ec0b74632
# ╠═907543c6-b7ed-4521-af21-d6fb86ce4518
# ╠═fe02352b-962a-4ac5-ba40-6b96112235ee
# ╠═1633fe05-cb51-4032-b6b6-f23db72bbd49
# ╠═7c312943-c48b-40e7-a499-227f7ff8aa59
# ╠═a0207e25-0398-4104-8c0f-a8fbd9fe1d53
# ╟─7d14b79c-74e5-4986-80b7-de7cd7d48670
# ╟─5950488e-2008-48d8-9095-7f9421df191e
# ╟─77cc33a3-c2bc-4f2d-ba88-e3693ec79b0c
# ╟─5a3a0f63-dcce-49c9-84fd-a6317184820f
# ╠═0f31dd2e-0331-4d4c-8db5-9ce188cd3730
# ╠═828e089e-64be-47c5-8e3c-7107adf02367
# ╠═bed3d31a-356a-4f9e-9a58-38b511f2b0e7
# ╠═b4e5b2a0-1ccb-4e10-bd5d-a26916568d69
# ╠═0a7a0d9e-034f-4f36-a57c-34b5d4ca896d
# ╠═17f0b235-bf0f-4ace-aaf1-ef3e5d325aad
# ╠═5e66e59b-fdb8-4373-b231-097b0227dc5c
# ╠═ba28d507-816f-45c0-b6c0-2f5f4f09855f
# ╠═ceb2c456-de9b-40a7-ac9f-3ba8d8708c2f
# ╠═af787ecf-b54e-4519-801d-eee323a1a2a3
# ╠═bd1d1541-134d-4c88-bb41-920ac36bfe92
# ╠═a661e172-6afb-42ff-bd43-bb5b787ee5ed
# ╠═930f8244-cf25-4c1a-95f6-5c8963559c62
# ╠═68ba60db-44ad-43e4-b33e-d27696babc99
# ╠═807bcd72-26c3-44d3-a295-56874cb51a89
# ╠═88f6a040-07cf-47e0-a8be-2478ea350aa7
# ╠═d36a8a72-eced-4e63-9130-7fcb6c86df76
# ╠═e9659020-d433-4357-9099-71a65b66a091
# ╠═c3fc3292-b7eb-4b01-8fba-159c86228de9
# ╠═89578bff-16b9-4eb2-b8ee-b2839ff2d74c
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
# ╠═8480d0d7-bdf7-468d-9344-5b789e33921c
# ╠═6f5ba692-4b6a-405a-8cd3-1a8f9cc06611
# ╠═b4b317d7-bed1-489c-9650-8d336e330689
# ╠═93ed973f-daf6-408b-9d4b-d53495418610
# ╠═dea898a0-1904-4d09-ad0b-6915008fe946
# ╟─b5763c10-e11c-4389-b6fc-421d2c9682f1
# ╠═74c19786-1ba7-4865-a993-590a779ae564
# ╠═e968fc57-d850-4e2d-9410-8777d03b7b3c
# ╟─3d5abd58-02ab-4b91-a7a3-d9068d4df017
# ╠═326f7661-3482-4bf2-a97b-57cc7ac60ee2
# ╟─b273d3d3-648f-4d34-94e7-e49277d4ba29
# ╠═a2cbb0c3-23b9-4091-9ca7-5ba96e85e3a3
# ╟─34f613a3-85fb-45a8-be3b-cd8e6b3cb5a2
# ╟─f9ed2487-a7f6-4ce9-b673-f8a298cd5fc3
# ╠═c55ae954-2d1e-4633-91e6-2c303ae40334
# ╟─b765dbfe-4e58-4bb9-b1d6-aa4378d4e9c9
# ╟─ef6fc423-f1b1-4dcb-a059-276121391bc6
# ╟─4d5f44e4-85e9-4985-9b76-73be5e097186
# ╟─dd495e00-d74d-47d4-a5d5-422fb147ec3b
# ╠═35f63c4e-3583-4ea8-a057-31f18f8a09d6
# ╟─35b2770e-1db6-4327-bf86-c27a4b61dbd3
# ╟─22640a2f-ea38-4517-a4f3-7a65e60ffebe
# ╟─d414f840-4952-4de5-a565-7fdc81a94817
# ╠═326825b0-a17f-427a-9056-8e8156098418
# ╟─64bf02a4-4fe3-424d-ae6e-5906c3395278
# ╟─f3916810-1911-48bd-936b-776206fcad54
# ╟─122c27a5-a6e8-45ef-a968-b9b4b3f9ad09
# ╟─9126f47d-cbc7-411f-93bd-8684ba06c9e9
# ╟─955705f9-c90d-495d-86b4-5f3b5bc9fc8e
# ╟─187c3005-cd43-45a0-8cbd-bc96b9cb39da
# ╠═daee414b-3e3c-4e2a-a25a-429a1e7275d5
# ╟─6c0156a9-7281-4326-9e1f-989efa73bb7b
# ╠═de62537b-a428-48d3-a866-151127b3255b
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
