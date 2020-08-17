### A Pluto.jl notebook ###
# v0.11.6

using Markdown
using InteractiveUtils

# ╔═╡ fec943e8-dfd0-11ea-016e-0f1925679545
begin
	using Images
	using LinearAlgebra
	using Plots
end

# ╔═╡ 7dd58888-dfd1-11ea-20e1-074ec76886dc
img_path = "/Users/richardbarana/Downloads/jordan.jpg"

# ╔═╡ 9a59bef8-dfd1-11ea-1a25-2d1e5eda238f
img = load(img_path)

# ╔═╡ 273c77f4-dfd2-11ea-1036-71c957f734c3
md"We make use of the `channelview` function from `Images`. It brings the color dim to the front; the 1st dim is the fastest."

# ╔═╡ 5d5dcbc6-dfd2-11ea-3af7-4340d82a250a
channels = channelview(img)

# ╔═╡ f9f3c54e-dfd2-11ea-0638-719714eddf53
md"We now have a 3 x 975 x 1457 matrix. The original was 975 x 1457."

# ╔═╡ 5a0b8264-e01e-11ea-20f3-273cbbdbd98b
function rank_approx(F::SVD, k)
	U, S, V = F
	M = U[:, 1:k]*Diagonal(S[1:k])*V[:, 1:k]'
	clamp01!(M)
end

# ╔═╡ 011fbba0-e020-11ea-15dd-9bf06bcf7f4b
md"We apply the `svd` function to each color channel; the `svdfactors` then correspond to three matrices U, S and Vt to each RGB channel."

# ╔═╡ f21af346-e01e-11ea-0c09-ad51fd263fe5
svdfactors = svd.(eachslice(channels; dims=1))

# ╔═╡ d5f4df2e-e020-11ea-3347-e79b46ba1748
md"We reconstruct the original image using the first `k` modes, through our defined function `rank_approx` and `colorview`."

# ╔═╡ 558a74dc-e020-11ea-3f74-2b9d997dc807
imgs = map((10, 50, 100)) do k
	colorview(RGB, rank_approx.(svdfactors, k)...)
end

# ╔═╡ 6a7879ba-e021-11ea-3967-3dd56af49590
md"Original and the SVD-reconstructed images for k=10, k=50 and k=100."

# ╔═╡ 2b936906-e021-11ea-1e63-ff05c32ab628
mosaicview(img, imgs...; nrow=1, npad=10)

# ╔═╡ 85e5728e-e030-11ea-28ee-bf1243de92d7
imgs[3]

# ╔═╡ 9d39045a-e030-11ea-3ac9-3bf32839a361
md"Reconstructing the red channel."

# ╔═╡ c757143e-e030-11ea-3ff2-f510b90ec733
Ur, Sr, Vtr = svdfactors[1]

# ╔═╡ cf430ed2-e030-11ea-140a-4146f5161e83
R = Ur*Diagonal(Sr)*Vtr'

# ╔═╡ db0bddfa-e030-11ea-25f1-4745abfb3ce1
RGB.(R)

# ╔═╡ 05f1417e-e031-11ea-2bbb-97b9aff20ae1
md"How many `k` modes do we need to reproduce the image without losing too much information?"

# ╔═╡ d38aeb58-e031-11ea-2e1d-bd9f7f0c99ff
md"Plotting the singular values we see the bigger ones are within k = {1, 50}."

# ╔═╡ 4003d674-e031-11ea-18a8-edc84866eb4b
plot(Sr, yaxis=:log, color=:red)

# ╔═╡ c8b2e60e-e031-11ea-1d47-43232dba2fb8
md"In fact, $$\approx$$ 70% of the variance is explained by `k`=100."

# ╔═╡ 378a6bf6-e032-11ea-080b-e75055bd5b30
plot(cumsum(Sr)/sum(Sr))

# ╔═╡ Cell order:
# ╠═fec943e8-dfd0-11ea-016e-0f1925679545
# ╟─7dd58888-dfd1-11ea-20e1-074ec76886dc
# ╠═9a59bef8-dfd1-11ea-1a25-2d1e5eda238f
# ╟─273c77f4-dfd2-11ea-1036-71c957f734c3
# ╠═5d5dcbc6-dfd2-11ea-3af7-4340d82a250a
# ╟─f9f3c54e-dfd2-11ea-0638-719714eddf53
# ╠═5a0b8264-e01e-11ea-20f3-273cbbdbd98b
# ╟─011fbba0-e020-11ea-15dd-9bf06bcf7f4b
# ╠═f21af346-e01e-11ea-0c09-ad51fd263fe5
# ╟─d5f4df2e-e020-11ea-3347-e79b46ba1748
# ╠═558a74dc-e020-11ea-3f74-2b9d997dc807
# ╟─6a7879ba-e021-11ea-3967-3dd56af49590
# ╠═2b936906-e021-11ea-1e63-ff05c32ab628
# ╠═85e5728e-e030-11ea-28ee-bf1243de92d7
# ╟─9d39045a-e030-11ea-3ac9-3bf32839a361
# ╠═c757143e-e030-11ea-3ff2-f510b90ec733
# ╠═cf430ed2-e030-11ea-140a-4146f5161e83
# ╠═db0bddfa-e030-11ea-25f1-4745abfb3ce1
# ╟─05f1417e-e031-11ea-2bbb-97b9aff20ae1
# ╟─d38aeb58-e031-11ea-2e1d-bd9f7f0c99ff
# ╠═4003d674-e031-11ea-18a8-edc84866eb4b
# ╟─c8b2e60e-e031-11ea-1d47-43232dba2fb8
# ╠═378a6bf6-e032-11ea-080b-e75055bd5b30
