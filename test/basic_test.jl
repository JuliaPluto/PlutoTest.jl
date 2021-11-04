### A Pluto.jl notebook ###
# v0.17.1

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

# ╔═╡ fbd777b9-1cb3-4d78-93c5-eae75c01b5dd
import HypertextLiteral

# ╔═╡ 80ffb0fa-1a23-4af6-968d-c02b641f5e6d
import Test

# ╔═╡ db2e67d8-7172-484e-ac91-85fd611326e6
md"---"

# ╔═╡ f00356a7-cadd-4363-8769-a2b0e3373ebc
import PlutoUI: Slider

# ╔═╡ 33eaf9ec-3da2-11ec-3db2-3ff3f1ba309a
module PlutoTestWrapper include("../src/PlutoTest.jl") end

# ╔═╡ db6dce9e-3cc0-4fce-8cb9-d0fb2d07cb62
import .PlutoTestWrapper.PlutoTest: @test

# ╔═╡ f9bdd61c-475c-4f17-8ccb-e7f85e7471a2
md"---"

# ╔═╡ 72244046-9b53-4953-8cc7-906279c7b4c8
x = [1,3]

# ╔═╡ d162b047-4c3a-4d91-9b97-210e51842996
@test x == [1,2+2]

# ╔═╡ 90b0b055-2dd1-4b28-a869-ec3a9b853b83
@test missing == 2

# ╔═╡ 0114b7be-36ac-4bbe-b52c-9d54742c7c91
@test 2+2 == 2+2

# ╔═╡ 5743b872-da02-4922-ae01-2e328a8cd3aa
@test rand(50) == [rand(50),2]

# ╔═╡ 9209719e-532f-4206-b2f8-eacd58a84d21
@bind howmuch Slider(0:100)

# ╔═╡ 6f619fbf-80a6-42b0-ab4f-9da28bc77970
@test isless(2+2,1)

# ╔═╡ b5d95cce-a4fa-4c86-8547-9ea25a9837c0
@test isless(1,2+2)

# ╔═╡ 9366cb04-476b-4bac-85fe-db64ccc4047a
@bind n Slider(1:10)

# ╔═╡ 4e8e065e-474d-45b3-9310-13a36521acd7
@test iseven(n^2)

# ╔═╡ e3993b93-dc70-4337-a98e-6fab7132a3b8
@bind k Slider(0:15)

# ╔═╡ ab1737e2-ee22-41d1-b63c-70da6c94facf
@test 4+4 ∈ [1:k...]

# ╔═╡ f03c135b-07f0-4783-97f9-d1a08e86a892
@test isempty((1:k) .^ 2)

# ╔═╡ 1fb3abd8-e49e-40da-848c-b81b1ff0dac3
@test isempty([1,sqrt(2)])

# ╔═╡ ed8170b3-3ef4-469f-aa5c-9ed240ed0e0b
begin
	i = 8
	@test sqrt(i) < 3
end

# ╔═╡ 4d8207ab-363d-4cb3-bf96-fe9c95482047
@test 1 ∈ [sqrt(20), 5:9...]

# ╔═╡ 1d4fd6d3-77d3-438c-8809-4388f23cd94e
@test 1 ∈ rand(60)

# ╔═╡ a16f12ea-0205-4a2b-94d9-0aa680358e4b
@test rand(60) ∋ 1

# ╔═╡ 3ea68a01-6022-437c-b9bf-0b4e34b80c2d
# Fons wtf
always_false(args...; kwargs...) = true

# ╔═╡ a82718bb-effa-4c93-9ef2-3985417e8820
@test always_false(rand(howmuch), rand(howmuch),123)

# ╔═╡ f7631f63-5942-4462-bac7-836119058a23
@test always_false(rand(2), rand(2),123)

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
Test = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[compat]
HypertextLiteral = "~0.9.2"
PlutoUI = "~0.7.18"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

[[AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "0ec322186e078db08ea3e7da5b8b2885c099b393"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.0"

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

[[Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[HypertextLiteral]]
git-tree-sha1 = "5efcf53d798efede8fee5b2c8b09284be359bf24"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.2"

[[IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "f7be53659ab06ddc986428d3a9dcc95f6fa6705a"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.2"

[[InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "8076680b162ada2a031f707ac7b4953e30667a37"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.2"

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

[[Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[Parsers]]
deps = ["Dates"]
git-tree-sha1 = "ae4bbcadb2906ccc085cf52ac286dc1377dceccc"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.1.2"

[[Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "Dates", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "57312c7ecad39566319ccf5aa717a20788eb8c1f"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.18"

[[Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[Random]]
deps = ["Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

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
# ╠═fbd777b9-1cb3-4d78-93c5-eae75c01b5dd
# ╠═80ffb0fa-1a23-4af6-968d-c02b641f5e6d
# ╟─db2e67d8-7172-484e-ac91-85fd611326e6
# ╠═f00356a7-cadd-4363-8769-a2b0e3373ebc
# ╠═33eaf9ec-3da2-11ec-3db2-3ff3f1ba309a
# ╠═db6dce9e-3cc0-4fce-8cb9-d0fb2d07cb62
# ╟─f9bdd61c-475c-4f17-8ccb-e7f85e7471a2
# ╠═72244046-9b53-4953-8cc7-906279c7b4c8
# ╠═d162b047-4c3a-4d91-9b97-210e51842996
# ╠═90b0b055-2dd1-4b28-a869-ec3a9b853b83
# ╠═0114b7be-36ac-4bbe-b52c-9d54742c7c91
# ╠═5743b872-da02-4922-ae01-2e328a8cd3aa
# ╠═a82718bb-effa-4c93-9ef2-3985417e8820
# ╠═9209719e-532f-4206-b2f8-eacd58a84d21
# ╠═f7631f63-5942-4462-bac7-836119058a23
# ╠═6f619fbf-80a6-42b0-ab4f-9da28bc77970
# ╠═b5d95cce-a4fa-4c86-8547-9ea25a9837c0
# ╠═9366cb04-476b-4bac-85fe-db64ccc4047a
# ╠═4e8e065e-474d-45b3-9310-13a36521acd7
# ╠═e3993b93-dc70-4337-a98e-6fab7132a3b8
# ╠═ab1737e2-ee22-41d1-b63c-70da6c94facf
# ╠═f03c135b-07f0-4783-97f9-d1a08e86a892
# ╠═1fb3abd8-e49e-40da-848c-b81b1ff0dac3
# ╠═ed8170b3-3ef4-469f-aa5c-9ed240ed0e0b
# ╠═4d8207ab-363d-4cb3-bf96-fe9c95482047
# ╠═1d4fd6d3-77d3-438c-8809-4388f23cd94e
# ╠═a16f12ea-0205-4a2b-94d9-0aa680358e4b
# ╠═3ea68a01-6022-437c-b9bf-0b4e34b80c2d
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
