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

# ╔═╡ 1c3b1ed7-4850-46a1-9ee2-dd4345f8df76
import HypertextLiteral: @htl

# ╔═╡ 63bf770c-d63a-4ed0-b084-90969f9f1aca
import Test

# ╔═╡ 3e1affff-1190-47c4-8c6f-b92adae5a9f6
import PlutoUI: Slider

# ╔═╡ 41228f59-e718-483a-b26b-3cd34d038c6c
module PlutoTestWrapper include("../src/PlutoTest.jl") end

# ╔═╡ 4b7f494f-9e51-4e5f-ae7a-1d8b9a889a5c
PlutoTest = PlutoTestWrapper.PlutoTest

# ╔═╡ a29032cd-b84d-4c92-ac78-d3c0d143fbe8
import .PlutoTest: @test

# ╔═╡ 5134af25-5c4d-492f-a22d-4c2aa8f0292c
@test π ≈ 3.14 atol=0.01 rtol=1

# ╔═╡ 9e54d70e-b342-4dcc-9298-d61ce8135f9f
@test [1, sqrt(sqrt(2)), 8^7]

# ╔═╡ 581a60a0-fe4b-4b76-b092-481c4c014091
x = [1,3]

# ╔═╡ 24568ff7-7f59-4579-93dc-87612d5ff8a8
@test x == [1,2+2]

# ╔═╡ 9ea60f6b-82cb-4afd-afe2-8021194e0c53
@test missing == 2

# ╔═╡ b83a7d1e-1f4d-4fd7-8014-36aed3e7cad4
@test 2+2 == 2+2

# ╔═╡ 7a066c6f-b754-4683-8af3-86e717dd78c7
@test rand(50) == [rand(50),2]

# ╔═╡ 439843d1-c379-497e-944c-d545391b93db
@bind howmuch Slider(0:100)

# ╔═╡ af40cd0c-6303-4f3a-bdc2-51253d57fd94
@test isless(2+2,1)

# ╔═╡ 39e84e22-b4fb-4aa2-a63b-a02ba4252a90
@test isless(1,2+2)

# ╔═╡ 9d90a13f-ad49-4e16-8728-e0594a34c9fd
@bind n Slider(1:10)

# ╔═╡ 816647a2-1161-4de7-9b3e-df3329266a9b
@test iseven(n^2)

# ╔═╡ 272cc3df-6463-4f35-9c1c-314106b107e0
@bind k Slider(0:15)

# ╔═╡ cc468d2d-3cd2-48d8-a0dd-bf5c33e395d1
@test 4+4 ∈ [1:k...]

# ╔═╡ 79458873-7e92-4559-9244-ce1ac32971f1
@test isempty((1:k) .^ 2)

# ╔═╡ 654fd088-4cbd-41ab-b276-dccf055545ee
@test isempty([1,sqrt(2)])

# ╔═╡ 6d1ed7d9-a8d6-4cff-8656-a4dffb357bd6
begin
	i = 8
	@test sqrt(i) < 3
end

# ╔═╡ 399d48e1-e238-4449-8ca7-3d889b25e4b8
@test 1 ∈ [sqrt(20), 5:9...]

# ╔═╡ 7175e07d-a023-4323-b3fd-43504b5e82a2
@test 1 ∈ rand(60)

# ╔═╡ 3cea1164-ef00-46cb-a005-aebfdcabd35f
@test rand(60) ∋ 1

# ╔═╡ 06fe1593-0420-4508-8404-c77d7daa87b2
# Fons wtf
always_false(args...; kwargs...) = true

# ╔═╡ ad0aceed-736b-49e6-96f8-0e70c109d609
@test always_false(rand(howmuch), rand(howmuch),123)

# ╔═╡ e3baf867-e3d3-4384-b9ef-8d787c3d4960
@test always_false(rand(2), rand(2),123)

# ╔═╡ c79825ca-4c57-4025-a1e4-4037da3d8849
@test !!always_false(rand(2), rand(2),123; r=123)

# ╔═╡ 77af5c23-823e-427f-83e5-7df2357c7861
@test always_false([1,2,3]...)

# ╔═╡ 130030d7-3eaf-492e-931f-e316ead71b45
map(1:10) do i
	@test sqrt(i) < 3 && always_false()
end

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
# ╠═1c3b1ed7-4850-46a1-9ee2-dd4345f8df76
# ╠═63bf770c-d63a-4ed0-b084-90969f9f1aca
# ╠═3e1affff-1190-47c4-8c6f-b92adae5a9f6
# ╠═41228f59-e718-483a-b26b-3cd34d038c6c
# ╠═4b7f494f-9e51-4e5f-ae7a-1d8b9a889a5c
# ╠═a29032cd-b84d-4c92-ac78-d3c0d143fbe8
# ╠═5134af25-5c4d-492f-a22d-4c2aa8f0292c
# ╠═9e54d70e-b342-4dcc-9298-d61ce8135f9f
# ╠═581a60a0-fe4b-4b76-b092-481c4c014091
# ╠═24568ff7-7f59-4579-93dc-87612d5ff8a8
# ╟─9ea60f6b-82cb-4afd-afe2-8021194e0c53
# ╠═b83a7d1e-1f4d-4fd7-8014-36aed3e7cad4
# ╠═7a066c6f-b754-4683-8af3-86e717dd78c7
# ╠═ad0aceed-736b-49e6-96f8-0e70c109d609
# ╠═439843d1-c379-497e-944c-d545391b93db
# ╠═e3baf867-e3d3-4384-b9ef-8d787c3d4960
# ╠═c79825ca-4c57-4025-a1e4-4037da3d8849
# ╠═77af5c23-823e-427f-83e5-7df2357c7861
# ╠═af40cd0c-6303-4f3a-bdc2-51253d57fd94
# ╠═39e84e22-b4fb-4aa2-a63b-a02ba4252a90
# ╠═9d90a13f-ad49-4e16-8728-e0594a34c9fd
# ╠═816647a2-1161-4de7-9b3e-df3329266a9b
# ╠═272cc3df-6463-4f35-9c1c-314106b107e0
# ╠═cc468d2d-3cd2-48d8-a0dd-bf5c33e395d1
# ╠═79458873-7e92-4559-9244-ce1ac32971f1
# ╠═130030d7-3eaf-492e-931f-e316ead71b45
# ╠═654fd088-4cbd-41ab-b276-dccf055545ee
# ╠═6d1ed7d9-a8d6-4cff-8656-a4dffb357bd6
# ╠═399d48e1-e238-4449-8ca7-3d889b25e4b8
# ╠═7175e07d-a023-4323-b3fd-43504b5e82a2
# ╠═3cea1164-ef00-46cb-a005-aebfdcabd35f
# ╠═06fe1593-0420-4508-8404-c77d7daa87b2
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
