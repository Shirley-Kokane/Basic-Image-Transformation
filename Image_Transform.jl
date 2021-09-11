### A Pluto.jl notebook ###
# v0.14.0

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

# ╔═╡ 65780f00-ed6b-11ea-1ecf-8b35523a7ac0
begin
	import Pkg
	Pkg.activate(mktempdir())
	Pkg.add([
			Pkg.PackageSpec(name="Images", version="0.22.4"), 
			Pkg.PackageSpec(name="ImageMagick", version="0.7"), 
			Pkg.PackageSpec(name="PlutoUI", version="0.7"), 
			Pkg.PackageSpec(name="HypertextLiteral", version="0.5")
			])

	using Images
	using PlutoUI
	using HypertextLiteral
end


filter!(LOAD_PATH) do path
	path != "@v#.#"
end;

using Statistics


student = (name = "Jazzy Doe", kerberos_id = "jazz")


md"""
#### Intializing packages

_When running this notebook for the first time, this could take up to 15 minutes. Hang in there!_
"""


md"""
## **Exercise 1** - _Manipulating vectors (1D images)_

A `Vector` is a 1D array. We can think of that as a 1D image.

"""


example_vector = [0.5, 0.4, 0.3, 0.2, 0.1, 0.0, 0.7, 0.0, 0.7, 0.9]


md"""
$(html"<br>")
#### Exerise 1.1
👉 Make a random vector `random_vect` of length 10 using the `rand` function.
"""


rando = (rand(1,10))




random_vect = [rando[1], rando[2], rando[3], rando[4], rando[5], rando[6], rando[7], rando[8], rando[9], rando[10]] 


begin
	colored_line(x::Vector) = hcat(Gray.(Float64.(x)))'
	colored_line(x::Any) = nothing
end


colored_line(example_vector)


colored_line(random_vect)


function my_sum(xs)
	# code here!
	sum = 0
	for i in 1:length(xs)
		
		sum += xs[i]
	end	
	return sum
		
end



function mean(xs)
	# code here!
	sum = 0
	for i in 1:length(xs)
		sum += xs[i]
	end
	men = sum/length(xs)
	return men
end


mean([1, 2, 3])


m = mean(random_vect) # replace `missing` with your code!




function demean(xs)
	# your code here!
	men = mean(xs)
	xt = zeros(Float64, length(xs))
	for i in 1:length(xs)
		xt[i] = xs[i] - men
	end	
	return xt
end


test_vect = let
	
	# feel free to change your test case here!
	to_create = [-1.0, -1.5, 8.5]
	
	
	
	
	demean
	to_create
end

# ╔═╡ 29e10640-edf0-11ea-0398-17dbf4242de3
md"To verify our function, let's check that the mean of the `demean(test_vect)` is 0: (_Due to floating-point round-off error it may *not* be *exactly* 0._)"

# ╔═╡ 1267e961-5b75-4b55-8080-d45316a03b9b
mean(test_vect)

# ╔═╡ 38155b5a-edf0-11ea-3e3f-7163da7433fb
demeaned_test_vect = demean(test_vect)

# ╔═╡ a5f8bafe-edf0-11ea-0da3-3330861ae43a
md"""
#### Exercise 1.5

👉 Generate a vector of 100 elements. Where:
- the center 20 elements are set to `1`, and
- all other elements are `0`.
"""

# ╔═╡ b6b65b94-edf0-11ea-3686-fbff0ff53d08
function create_bar()
	vec = zeros(Float64, 100)
	for i in 40:60
		vec[i] = 1
	end	
	return vec
end

# ╔═╡ 4a5e9d2c-dd90-4bb0-9e31-3f5c834406b4
create_bar()

# ╔═╡ d862fb16-edf1-11ea-36ec-615d521e6bc0
colored_line(create_bar())

# ╔═╡ 59414833-a108-4b1e-9a34-0f31dc907c6e
url = "https://user-images.githubusercontent.com/6933510/107239146-dcc3fd00-6a28-11eb-8c7b-41aaf6618935.png" 

# ╔═╡ c5484572-ee05-11ea-0424-f37295c3072d
philip_filename = download(url) # download to a local file. The filename is returned

# ╔═╡ c8ecfe5c-ee05-11ea-322b-4b2714898831
philip = load(philip_filename)

# ╔═╡ e86ed944-ee05-11ea-3e0f-d70fc73b789c
md"_Hi there Philip_"

# ╔═╡ 6ccd8902-0dd9-4335-a11a-ee7f9a1a6c09
philip_head = philip[470:800, 140:410]

# ╔═╡ 15088baa-c337-405d-8885-19a6e2bfd6aa
md"""
Recall from [Section 1.1](https://computationalthinking.mit.edu/Spring21/week1/) that in Julia, an _image_ is just a 2D array of color objects:
"""

# ╔═╡ 7ad4f6bc-588e-44ab-8ca9-c87cd1048442
typeof(philip)

# ╔═╡ a55bb5ca-600b-4aa0-b95f-7ece20845c9b
md"""
Every pixel (i.e. _element of the 2D array_) is of the `RGB` type:
"""

# ╔═╡ c5dc0cc8-9305-47e6-8b20-a9f8ef867799
philip_pixel = philip[100,100]

# ╔═╡ de772e21-0bea-4fd2-868a-9a7d32550bc9
typeof(philip_pixel)

# ╔═╡ 21bdc692-91ee-474d-ae98-455913a2342e
md"""
To get the values of its individual color channels, use the `r`, `g` and `b` _attributes_:
"""

# ╔═╡ 2ae3f379-96ce-435d-b863-deba4586ec71
philip_pixel.r, philip_pixel.g, philip_pixel.b

# ╔═╡ c49ba901-d798-489a-963c-4cc113c7abfd
md"""
And to create an `RGB` object yourself:
"""

# ╔═╡ 93451c37-77e1-4d4f-9788-c2a3da1401ee
RGB(0.1, 0.4, 0.7)

# ╔═╡ f52e4914-2926-4a42-9e45-9caaace9a7db
md"""
#### Exerise 2.1
👉 Write a function **`get_red`** that takes a single pixel, and returns the value of its red channel.
"""

# ╔═╡ a8b2270a-600c-4f83-939e-dc5ab35f4735
function get_red(pixel::AbstractRGB)
	# your code here!
	
	return pixel.r
end

# ╔═╡ c320b39d-4cea-4fa1-b1ce-053c898a67a6
get_red(RGB(0.8, 0.1, 0.0))

# ╔═╡ d8cf9bd5-dbf7-4841-acf9-eef7e7cabab3
md"""
#### Exerise 2.2
👉 Write a function **`get_reds`** (note the extra `s`) that accepts a 2D color array called `image`, and returns a 2D array with the red channel value of each pixel. (The result should be a 2D array of _numbers_.) Use your function `get_red` from the previous exercise.
"""

# ╔═╡ ebe1d05c-f6aa-437d-83cb-df0ba30f20bf
function get_reds(image::AbstractMatrix)
	# your code here!
	
	col = length(image[1,:])
	row = length(image[:,1])
	vec = zeros(Float64, row, col)
	for r in 1:(row)
		for c in 1:col
			vec[r,c] = image[r,c].r
		end
	end	
	return vec
end

# ╔═╡ c427554a-6f6a-43f1-b03b-f83239887cee
get_reds(philip_head)

# ╔═╡ 4fd07e01-2f8b-4ec9-9f4f-8a9e5ff56fb6
md"""

Great! By extracting the red channel value of each pixel, we get a 2D array of numbers. We went from an image (2D array of RGB colors) to a matrix (2D array of numbers).

#### Exerise 2.3
Let's try to visualize this matrix. Right now, it is displayed in text form, but because the image is quite large, most rows and columns don't fit on the screen. Instead, a better way to visualize it is to **view a number matrix as an image**.

This is easier than you might think! We just want to map each number to an `RGB` object, and the result will be a 2D array of `RGB` objects, which Julia will display as an image.

First, let's define a function that turns a _number_ into a _color_.
"""

# ╔═╡ 97c15896-6d99-4292-b7d7-4fcd2353656f
function value_as_color(x)
	
	return RGB(x, 0, 0)
end

# ╔═╡ cbb9bf41-4c21-42c7-b0e0-fc1ce29e0eb1
value_as_color(0.0), value_as_color(0.6), value_as_color(1.0)

# ╔═╡ 3f1a670b-44c2-4cab-909c-65f4ae9ed14b
md"""
👉 Use the functions `get_reds` and `value_as_color` to visualize the red channel values of `philip_head`. Tip: Like in previous exercises, use broadcasting ('dot syntax') to apply a function _element-wise_.

Use the ➕ button at the bottom left of this cell to add more cells.
"""

# ╔═╡ 21ba6e75-55a2-4614-9b5d-ea6378bf1d98
mat= get_reds(philip_head)


# ╔═╡ 3792c3e9-c6a3-40b9-815f-1e011f913967
function get_color(mat)
	clr = []
	for r in 1:length(mat[:,1])
		for c in 1:length(mat[1,:])
			append!(clr, mat[r,c])
		end
	end
	for l in 1:length(clr)
		println(value_as_color(clr[l]))
	end			
			#println(rit)
			#return clr
	
	
		
end	
			
			

# ╔═╡ 10b267c5-f4ff-488f-8274-fad66a0af716
get_color(mat)

# ╔═╡ f7825c18-ff28-4e23-bf26-cc64f2f5049a
md"""

#### Exerise 2.4
👉 Write four more functions, `get_green`, `get_greens`, `get_blue` and `get_blues`, to be the equivalents of `get_red` and `get_reds`. Use the ➕ button at the bottom left of this cell to add new cells.
"""

# ╔═╡ d994e178-78fd-46ab-a1bc-a31485423cad
vec = get_reds(philip_head)

# ╔═╡ 2b2ae8b0-97fd-4ccf-ae9f-79c074c806e0
mean(vec)

# ╔═╡ c54ccdea-ee05-11ea-0365-23aaf053b7d7
md"""
#### Exercise 2.5
👉 Write a function **`mean_color`** that accepts an object called `image`. It should calculate the mean amounts of red, green and blue in the image and return the average color. Be sure to use functions from previous exercises!
"""

# ╔═╡ c182bf1f-2e3f-40de-964f-dc077ec84703
function get_blues(image::AbstractMatrix)
	# your code here!
	
	col = length(image[1,:])
	row = length(image[:,1])
	vec = zeros(Float64, row, col)
	for r in 1:(row)
		for c in 1:col
			vec[r,c] = image[r,c].b
		end
	end	
	return vec
end

# ╔═╡ 4010780a-cad8-43bc-930c-467738f769ce
function get_greens(image::AbstractMatrix)
	# your code here!
	
	col = length(image[1,:])
	row = length(image[:,1])
	vec = zeros(Float64, row, col)
	for r in 1:(row)
		for c in 1:col
			vec[r,c] = image[r,c].g
		end
	end	
	return vec
end

# ╔═╡ 97433d88-29f8-46e4-95fa-e11e49e3bb74


# ╔═╡ f6898df6-ee07-11ea-2838-fde9bc739c11
function mean_color(image)
	red = mean(get_reds(image))
	blue = mean(get_blues(image))
	green = mean(get_greens(image))
	return RGB(red, green, blue)
end

# ╔═╡ 5be9b144-ee0d-11ea-2a8d-8775de265a1d
mean_color(philip)

# ╔═╡ 5f6635b4-63ed-4a62-969c-bd4084a8202f
md"""
_At the end of this homework, you can see all of your filters applied to your webcam image!_
"""

# ╔═╡ 63e8d636-ee0b-11ea-173d-bd3327347d55
function invert(color::AbstractRGB)
	
	return RGB(1- color.r , 1- color.g, 1-color.b)
end

# ╔═╡ 2cc2f84e-ee0d-11ea-373b-e7ad3204bb00
md"Let's invert some colors:"

# ╔═╡ b8f26960-ee0a-11ea-05b9-3f4bc1099050
color_black = RGB(0.0, 0.0, 0.0)

# ╔═╡ 5de3a22e-ee0b-11ea-230f-35df4ca3c96d
invert(color_black)

# ╔═╡ 4e21e0c4-ee0b-11ea-3d65-b311ae3f98e9
color_red = RGB(0.8, 0.1, 0.1)

# ╔═╡ 6dbf67ce-ee0b-11ea-3b71-abc05a64dc43
invert(color_red)

# ╔═╡ de81f1c2-9784-4e61-9bc3-930101b0933c
vecr = get_reds(philip)
	

# ╔═╡ 22ad8b1e-ba39-44ef-89a5-59431b43f109
vecg = get_greens(philip)

# ╔═╡ 30491199-c923-44e1-9f33-7914adc4a1c5
vecb = get_blues(philip)

# ╔═╡ 846b1330-ee0b-11ea-3579-7d90fafd7290
md"👉 Can you invert the picture of Philip?"

# ╔═╡ 943103e2-ee0b-11ea-33aa-75a8a1529931
function invert_image(philip)
	c = length(philip[1,:])
	r = length(philip[:,1])
	philip_inverted = rand(RGB{Float64}, r, c)
	for i in 1:c
		for j in 1:r
		
			philip_inverted[r+1-j,c+1-i] = (philip[j,i])	
		end	
		#end
	end		
	#end
	return philip_inverted
	
end	

# ╔═╡ f5c85eae-8c00-4e32-b715-94464321e04d
invert_image(philip)

# ╔═╡ 55b138b7-19fb-4da1-9eb1-1e8304528251
md"""
_At the end of this homework, you can see all of your filters applied to your webcam image!_
"""

# ╔═╡ f68d4a36-ee07-11ea-0832-0360530f102e
md"""
#### Exercise 3.2
👉 Look up the documentation on the `floor` function. Use it to write a function `quantize(x::Number)` that takes in a value $x$ (which you can assume is between 0 and 1) and "quantizes" it into bins of width 0.1. For example, check that 0.267 gets mapped to 0.2.
"""

# ╔═╡ fbd1638d-8d7a-4d12-aff9-9c160cc3fd74
function quantize(x::Number)
	# your code here!
	y = floor(10*x)
	return (0.1*y)
end

# ╔═╡ 7720740e-2d2b-47f7-98fd-500ed3eee479
md"""
#### Intermezzo: _multiple methods_

In Julia, we often write multiple methods for the same function. When a function is called, the method is chosen based on the input arguments. Let's look at an example:

These are two _methods_ to the same function, because they have 

> **the same name, but different input types**
"""

# ╔═╡ 90421bca-0804-4d6b-8bd0-3ddbd54cc5fe
function double(x::Number)
	
	return x * 2
end

# ╔═╡ b2329e4c-6204-453e-8998-2414b869b808
function double(x::Vector)
	
	return [x..., x...]
end

# ╔═╡ 23fcd65f-0182-41f3-80ec-d85b05136c47
md"""
When we call the function `double`, Julia will decide which method to call based on the given input argument!
"""

# ╔═╡ 5055b74c-b98d-41fa-a0d8-cb36200d82cc
double(24)

# ╔═╡ 8db17b2b-0cf9-40ba-8f6f-2e53be7b6355
double([1,2,37])

# ╔═╡ a8a597e0-a01c-40cd-9902-d56430afd938
md"""
We call this **multiple dispatch**, and it is one of Julia's key features. Throughout this course, you will see lots of real-world application, and learn to use multiple dispatch to create flexible and readable abstractions!
"""

# ╔═╡ f6b218c0-ee07-11ea-2adb-1968c4fd473a
md"""
#### Exercise 3.3
👉 Write the second **method** of the function `quantize`, i.e. a new *version* of the function with the *same* name. This method will accept a color object called `color`, of the type `AbstractRGB`. 
    
Here, `::AbstractRGB` is a **type annotation**. This ensures that this version of the function will be chosen when passing in an object whose type is a **subtype** of the `AbstractRGB` abstract type. For example, both the `RGB` and `RGBX` types satisfy this.

The method you write should return a new `RGB` object, in which each component ($r$, $g$ and $b$) are quantized. Use your previous method for `quantize`!
"""

# ╔═╡ 04e6b486-ceb7-45fe-a6ca-733703f16357
function quantize(color::AbstractRGB)
	# your code here!
	r = quantize(color.r)
	g = quantize(color.g)
	b = quantize(color.b)
	return RGB(r,g,b)
end

# ╔═╡ f6bf64da-ee07-11ea-3efb-05af01b14f67
md"""
#### Exercise 3.4
👉 Write a method `quantize(image::AbstractMatrix)` that quantizes an image by quantizing each pixel in the image. (You may assume that the matrix is a matrix of color objects.)
"""

# ╔═╡ 13e9ec8d-f615-4833-b1cf-0153010ccb65
function quantize(image::AbstractMatrix)
	# your code here!
	new_image = rand(RGB{Float64}, length(image[:,1]), length(image[1,:]))
	for i in 1:length(image[:,1])
		for j in 1:length(image[1,:])
			new_image[i,j] = RGB(quantize(image[i,j].r) , quantize(image[i,j].g), 										quantize(image[i,j].b))
		end
	end	
	return new_image
end

# ╔═╡ f6a655f8-ee07-11ea-13b6-43ca404ddfc7
quantize(0.267), quantize(0.91)

# ╔═╡ 25dad7ce-ee0b-11ea-3e20-5f3019dd7fa3
md"Let's apply your method!"

# ╔═╡ 9751586e-ee0c-11ea-0cbb-b7eda92977c9
quantize(philip)

# ╔═╡ f6d6c71a-ee07-11ea-2b63-d759af80707b
md"""
#### Exercise 3.5
👉 Write a function `noisify(x::Number, s)` to add randomness of intensity $s$ to a value $x$, i.e. to add a random value between $-s$ and $+s$ to $x$. If the result falls outside the range $[0, 1]$ you should "clamp" it to that range. (Julia has a built-in `clamp` function, or you can write your own function.)
"""

# ╔═╡ f38b198d-39cf-456f-a841-1ba08f206010
function noisify(x::Number, s)
	# your code here!
	t = rand()
	d = clamp(t,0,1)
	return x+d
end

# ╔═╡ f6fc1312-ee07-11ea-39a0-299b67aee3d8
md"""
👉  Write the second method `noisify(c::AbstractRGB, s)` to add random noise of intensity $s$ to each of the $(r, g, b)$ values in a colour. 

Use your previous method for `noisify`. _(Remember that Julia chooses which method to use based on the input arguments. So to call the method from the previous exercise, the first argument should be a number.)_
"""

# ╔═╡ db4bad9f-df1c-4640-bb34-dd2fe9bdce18
function noisify(color::AbstractRGB, color_noise)
	# your code here!
	s = color_noise
	#colr = rand(RGB{Float64} ,1)
	#colr = (color) + s
	#colr.g = quantize(color.g) + s
	#colr.b = quantize(color.b) + s
	return RGB(color.r +s, color.g + s, color.b+s)
end

# ╔═╡ 0000b7f8-4c43-4dd8-8665-0dfe59e74c0a
md"""
Noise strength:
"""

# ╔═╡ 774b4ce6-ee1b-11ea-2b48-e38ee25fc89b
@bind color_noise Slider(0:0.01:1, show_value=true)

# ╔═╡ 48de5bc2-72d3-11eb-3fd9-eff2b686cb75
md"""
> ### Note about _array comprehension_
> At this point, you already know of a few ways to make a new array based on one that already exists.
> 1. you can use a for loop to go through a array
> 1. you can use function broadcasting over a array
> 1. you can use _**array comprehension**_!
>
> The third option you are about to see demonstrated below and following the following syntax:
>
> ```[function_to_apply(args) for args in some_iterable_of_your_choice]```
>
> This creates a new iterable that matches what you iterate through in the second part of the comprehension. Below is an example with `for` loops through two iterables that creates a 2-dimensional `Array`.
"""

# ╔═╡ f70823d2-ee07-11ea-2bb3-01425212aaf9
md"""
👉 Write the third method `noisify(image::AbstractMatrix, s)` to noisify each pixel of an image. This function should be a single line!
"""

# ╔═╡ 21a5885d-00ab-428b-96c3-c28c98c4ca6d
function noisify(image::AbstractMatrix, s)
	# your code here!
	new_image = rand(RGB{Float64}, length(image[:,1]), length(image[1,:]))
	for i in 1:length(image[:,1])
		for j in 1:length(image[1,:])
			new_image[i,j] = noisify(image[i,j],s)
		end
	end	
	return new_image
end

# ╔═╡ 1ea53f41-b791-40e2-a0f8-04e13d856829
noisify(0.5, 0.1) # edit this test case!

# ╔═╡ 7e4aeb70-ee1b-11ea-100f-1952ba66f80f
(original=color_red, with_noise=noisify(color_red, color_noise))

# ╔═╡ 8e848279-1b3e-4f32-8c0c-45693d12de96
[
	noisify(color_red, strength)
	for 
		strength in 0 : 0.05 : 1,
		row in 1:10
]'

# ╔═╡ d896b7fd-20db-4aa9-bbcf-81b1cd44ec46
md"""

#### Exerise 3.6
Move the slider below to set the amount of noise applied to the image of Philip.
"""

# ╔═╡ e70a84d4-ee0c-11ea-0640-bf78653ba102
@bind philip_noise Slider(0:0.01:1, show_value=true)

# ╔═╡ ac15e0d0-ee0c-11ea-1eaf-d7f88b5df1d7
noisify(philip_head, philip_noise)

# ╔═╡ 9604bc44-ee1b-11ea-28f8-7f7af8d0cbb2
if philip_noise == 1
	md"""
	> #### What's this?
	> 
	> The noise intensity is `1.0`, but we can still recognise Philip in the picture... 
	> 
	> 👉 Modify the definition of the slider to go further than `1.0`.
	"""
end

# ╔═╡ f714699e-ee07-11ea-08b6-5f5169861b57
md"""
👉 For which noise intensity does it become unrecognisable? 

You may need noise intensities larger than 1. Why?

"""

# ╔═╡ bdc2df7c-ee0c-11ea-2e9f-7d2c085617c1
answer_about_noise_intensity = md"""
The image is unrecognisable with intensity ...
"""

# ╔═╡ e87e0d14-43a5-490d-84d9-b14ece472061
md"""
### Results
"""

# ╔═╡ ee5f21fb-1076-42b6-8926-8bbb6ed0ad67
function custom_filter(pixel::AbstractRGB)
	
	# your code here!
	
	return pixel
end

# ╔═╡ 9e5a08dd-332a-486b-94ab-15c49e72e522
function custom_filter(image::AbstractMatrix)
	
	return custom_filter.(image)
end

# ╔═╡ 8ffe16ce-ee20-11ea-18bd-15640f94b839
if student.kerberos_id === "jazz"
	md"""
!!! danger "Oops!"
    **Before you submit**, remember to fill in your name and kerberos ID at the top of this notebook!
	"""
end

# ╔═╡ 756d150a-b7bf-4bf5-b372-5b0efa80d987
md"## Function library

Just some helper functions used in the notebook."

# ╔═╡ 4bc94bec-da39-4f8a-82ee-9953ed73b6a4
hint(text) = Markdown.MD(Markdown.Admonition("hint", "Hint", [text]))

# ╔═╡ b1d5ca28-edf6-11ea-269e-75a9fb549f1d
md"""
You can find out more about any function (like `rand`) by clicking on the Live Docs in the bottom right of this Pluto window, and typing a function name in the top.

![image](https://user-images.githubusercontent.com/6933510/107848812-c934df80-6df6-11eb-8a32-663d802f5d11.png)


![image](https://user-images.githubusercontent.com/6933510/107848846-0f8a3e80-6df7-11eb-818a-7271ecb9e127.png)

We recommend that you leave the window open while you work on Julia code. It will continually look up documentation for anything you type!

#### Help, I don't see the Live Docs!

Try the following:

🙋 **Are you viewing a static preview?** The Live Docs only work if you _run_ the notebook. If you are reading this on our course website, then click the button in the top right to run the notebook.

🙋 **Is your screen too small?** Try resizing your window or zooming out.
""" |> hint

# ╔═╡ 24090306-7395-4f2f-af31-34f7486f3945
hint(md"""Check out this page for a refresher on basic Julia syntax:
	
	[Basic Julia Syntax](https://computationalthinking.mit.edu/Spring21/basic_syntax/)""")

# ╔═╡ aa1ff74a-4e78-4ef1-8b8d-3a60a168cf6d
hint(md"""
In [Section 1.1](https://computationalthinking.mit.edu/Spring21/week1/), we drew a red square on top of the image Philip with a simple command...
""")

# ╔═╡ 50e2b0fb-b06d-4ac1-bdfb-eab833466736
md"""
This exercise can be quite difficult if you use a `for` loop or list comprehension. 

Instead, you should use the [dot syntax](https://docs.julialang.org/en/v1/manual/functions/#man-vectorized) to apply a function _element-wise_ to an array. For example, this is how you get the square root of `3`:

```
sqrt(3)
```

and this is how you get the square roots of 1, 2 and 3:

```
sqrt.([1, 2, 3])
```

""" |> hint

# ╔═╡ f6ef2c2e-ee07-11ea-13a8-2512e7d94426
hint(md"`rand()` generates a (uniformly) random floating-point number between $0$ and $1$.")

# ╔═╡ 8ce6ad06-819c-4af5-bed7-56ecc08c97be
almost(text) = Markdown.MD(Markdown.Admonition("warning", "Almost there!", [text]))

# ╔═╡ dfa40e89-03fc-4a7a-825e-92d67ee217b2
still_missing(text=md"Replace `missing` with your answer.") = Markdown.MD(Markdown.Admonition("warning", "Here we go!", [text]))

# ╔═╡ 086ec1ff-b62d-4566-9973-5b2cc3353409
keep_working(text=md"The answer is not quite right.") = Markdown.MD(Markdown.Admonition("danger", "Keep working on it!", [text]))

# ╔═╡ 2f6fb3a6-bb5d-4c7a-9297-84dd4b16c7c3
yays = [md"Fantastic!", md"Splendid!", md"Great!", md"Yay ❤", md"Great! 🎉", md"Well done!", md"Keep it up!", md"Good job!", md"Awesome!", md"You got the right answer!", md"Let's move on to the next section."]

# ╔═╡ c22f688b-dc04-4a94-b541-fe06266c5446
correct(text=rand(yays)) = Markdown.MD(Markdown.Admonition("correct", "Got it!", [text]))

# ╔═╡ 09102183-f9fb-4d89-b4f9-5d76af7b8e90
let
	result = get_red(RGB(0.2, 0.3, 0.4))
	if ismissing(result)
		still_missing()
	elseif isnothing(result)
		keep_working(md"Did you forget to write `return`?")
	elseif result == 0.2
		correct()
	else
		keep_working()
	end
end

# ╔═╡ 63ac142e-6d9d-4109-9286-030a02c900b4
let
	test = [RGB(0.2, 0, 0)   RGB(0.6, 0, 0)]
	result = get_reds(test)
	
	if ismissing(result)
		still_missing()
	elseif isnothing(result)
		keep_working(md"Did you forget to write `return`?")
	elseif result == [ 0.2  0.6 ]
		correct()
	else
		keep_working()
	end
end

# ╔═╡ 80a4cb23-49c9-4446-a3ec-b2203128dc27
let
	result = invert(RGB(1.0, 0.5, 0.25)) # I chose these values because they can be represented exactly by Float64
	shouldbe = RGB(0.0, 0.5, 0.75)
	
	if ismissing(result)
		still_missing()
	elseif isnothing(result)
		keep_working(md"Did you forget to write `return`?")
	elseif !(result isa AbstractRGB)
		keep_working(md"You need to return a _color_, i.e. an object of type `RGB`. Use `RGB(r, g, b)` to create a color with channel values `r`, `g` and `b`.")
	elseif !(result == shouldbe)
		keep_working()
	else
		correct()
	end
end

# ╔═╡ a6d9635b-85ed-4590-ad09-ca2903ea8f1d
let
	result = quantize(RGB(.297, .1, .0))

	if ismissing(result)
		still_missing()
	elseif isnothing(result)
		keep_working(md"Did you forget to write `return`?")
	elseif !(result isa AbstractRGB)
		keep_working(md"You need to return a _color_, i.e. an object of type `RGB`. Use `RGB(r, g, b)` to create a color with channel values `r`, `g` and `b`.")
	elseif result != RGB(0.2, .1, .0)
		keep_working()
	else
		correct()
	end
end

# ╔═╡ 31ef3710-e4c9-4aa7-bd8f-c69cc9a977ee
let
	result = noisify(0.5, 0)

	if ismissing(result)
		still_missing()
	elseif isnothing(result)
		keep_working(md"Did you forget to write `return`?")
	elseif result == 0.5
		
		results = [noisify(0.9, 0.1) for _ in 1:1000]
		
		if 0.8 ≤ minimum(results) < 0.81 && 0.99 ≤ maximum(results) ≤ 1
			result = noisify(5, 3)
			
			if result == 1
				correct()
			else
				keep_working(md"The result should be restricted to the range ``[0,1]``.")
			end
		else
			keep_working()
		end
	else
		keep_working(md"What should `noisify(0.5, 0)` be?")
		correct()
	end
end

# ╔═╡ ab3d1b70-88e8-4118-8d3e-601a8a68f72d
not_defined(variable_name) = Markdown.MD(Markdown.Admonition("danger", "Oopsie!", [md"Make sure that you define a variable called **$(Markdown.Code(string(variable_name)))**"]))

# ╔═╡ 397941fc-edee-11ea-33f2-5d46c759fbf7
if !@isdefined(random_vect)
	not_defined(:random_vect)
elseif ismissing(random_vect)
	still_missing()
elseif !(random_vect isa Vector)
	keep_working(md"`random_vect` should be a `Vector`.")
elseif eltype(random_vect) != Float64
	almost(md"""
		You generated a vector of random integers. For the remaining exercises, we want a vector of `Float64` numbers. 
		
		The (optional) first argument to `rand` specifies the **type** of elements to generate. For example: `rand(Bool, 10)` generates 10 values that are either `true` or `false`. (Try it!)
		""")
elseif length(random_vect) != 10
	keep_working(md"`random_vect` does not have the correct size.")
elseif length(Set(random_vect)) != 10
	keep_working(md"`random_vect` is not 'random enough'")
else
	correct(md"Well done! You can run your code again to generate a new vector!")
end

# ╔═╡ e0bfc973-2808-4f84-b065-fb3d05401e30
if !@isdefined(my_sum)
	not_defined(:my_sum)
else
	let
		result = my_sum([1,2,3])
		if ismissing(result)
			still_missing()
		elseif isnothing(result)
			keep_working(md"Did you forget to write `return`?")
		elseif result != 6
			keep_working()
		else
			correct()
		end
	end
end

# ╔═╡ 38dc80a0-edef-11ea-10e9-615255a4588c
if !@isdefined(mean)
	not_defined(:mean)
else
	let
		result = mean([1,2,3])
		if ismissing(result)
			still_missing()
		elseif isnothing(result)
			keep_working(md"Did you forget to write `return`?")
		elseif result != 2
			keep_working()
		else
			correct()
		end
	end
end

# ╔═╡ 2b1ccaca-edee-11ea-34b0-c51659f844d0
if !@isdefined(m)
	not_defined(:m)
elseif ismissing(m)
	still_missing()
elseif !(m isa Number)
	keep_working(md"`m` should be a number.")
elseif m != mean(random_vect)
	keep_working()
else
	correct()
end

# ╔═╡ adf476d8-a334-4b35-81e8-cc3b37de1f28
if !@isdefined(mean)
	not_defined(:mean)
else
	let
		input = Float64[1,2,3]
		result = demean(input)
		
		if input === result
			almost(md"""
			It looks like you **modified** `xs` inside the function.
			
			It is preferable to avoid mutation inside functions, because you might want to use the original data again. For example, applying `demean` to a dataset of sensor readings would **modify** the original data, and the rest of your analysis would be erroneous.
			
			""")
		elseif ismissing(result)
			still_missing()
		elseif isnothing(result)
			keep_working(md"Did you forget to write `return`?")
		elseif !(result isa AbstractVector) || length(result) != 3
			keep_working(md"Return a vector of the same size as `xs`.")
		elseif abs(sum(result) / 3) < 1e-10
			correct()
		else
			keep_working()
		end
	end
end

# ╔═╡ e3394c8a-edf0-11ea-1bb8-619f7abb6881
if !@isdefined(create_bar)
	not_defined(:create_bar)
else
	let
		result = create_bar()
		if ismissing(result)
			still_missing()
		elseif isnothing(result)
			keep_working(md"Did you forget to write `return`?")
		elseif !(result isa Vector) || length(result) != 100
			keep_working(md"The result should be a `Vector` with 100 elements.")
		elseif result[[1,50,100]] != [0,1,0]
			keep_working()
		else
			correct()
		end
	end
end

# ╔═╡ 4d0158d0-ee0d-11ea-17c3-c169d4284acb
if !@isdefined(mean_color)
	not_defined(:mean_color)
else
	let
		input = reshape([RGB(1.0, 1.0, 1.0), RGB(1.0, 1.0, 0.0)], (2, 1))
		
		result = mean_color(input)
		shouldbe = RGB(1.0, 1.0, 0.5)

		if ismissing(result)
			still_missing()
		elseif isnothing(result)
			keep_working(md"Did you forget to write `return`?")
		elseif !(result isa AbstractRGB)
			keep_working(md"You need to return a _color_, i.e. an object of type `RGB`. Use `RGB(r, g, b)` to create a color with channel values `r`, `g` and `b`.")
		elseif !(result == shouldbe)
			keep_working()
		else
			correct()
		end
	end
end

# ╔═╡ c905b73e-ee1a-11ea-2e36-23b8e73bfdb6
if !@isdefined(quantize)
	not_defined(:quantize)
else
	let
		result = quantize(.3)

		if ismissing(result)
			still_missing()
		elseif isnothing(result)
			keep_working(md"Did you forget to write `return`?")
		elseif result != .3
			if quantize(0.35) == .3
				almost(md"What should quantize(`0.2`) be?")
			else
				keep_working()
			end
		else
			correct()
		end
	end
end

# ╔═╡ 8cb0aee8-5774-4490-9b9e-ada93416c089
todo(text) = HTML("""<div
	style="background: rgb(220, 200, 255); padding: 2em; border-radius: 1em;"
	><h1>TODO</h1>$(repr(MIME"text/html"(), text))</div>""")

# ╔═╡ 115ded8c-ee0a-11ea-3493-89487315feb7
bigbreak = html"<br><br><br><br><br>";

# ╔═╡ 54056a02-ee0a-11ea-101f-47feb6623bec
bigbreak

# ╔═╡ e083b3e8-ed61-11ea-2ec9-217820b0a1b4
md"""
 $(bigbreak)

## **Exercise 2** - _Manipulating images_

In this exercise we will get familiar with matrices (2D arrays) in Julia, by manipulating images.
Recall that in Julia images are matrices of `RGB` color objects.

Let's load a picture of Philip again.
"""

# ╔═╡ f6cc03a0-ee07-11ea-17d8-013991514d42
md"""
 $(bigbreak)

## Exercise 3 - _More filters_

In the previous exercises, we learned how to use Julia's _dot syntax_ to apply a function _element-wise_ to an array. In this exercise, we will use this to write more image filters, that you can then apply to your own webcam image!

#### Exercise 3.1
👉 Write a function `invert` that inverts a color, i.e. sends $(r, g, b)$ to $(1 - r, 1-g, 1-b)$.
"""

# ╔═╡ 4139ee66-ee0a-11ea-2282-15d63bcca8b8
md"""
$(bigbreak)
### Camera input
"""

# ╔═╡ 87dabfd2-461e-4769-ad0f-132cb2370b88
md"""
$(bigbreak)
### Write your own filter!
"""

# ╔═╡ 91f4778e-ee20-11ea-1b7e-2b0892bd3c0f
bigbreak

# ╔═╡ 5842895a-ee10-11ea-119d-81e4c4c8c53b
bigbreak

# ╔═╡ dfb7c6be-ee0d-11ea-194e-9758857f7b20
function camera_input(;max_size=200, default_url="https://i.imgur.com/SUmi94P.png")
"""
<span class="pl-image waiting-for-permission">
<style>
	
	.pl-image.popped-out {
		position: fixed;
		top: 0;
		right: 0;
		z-index: 5;
	}

	.pl-image #video-container {
		width: 250px;
	}

	.pl-image video {
		border-radius: 1rem 1rem 0 0;
	}
	.pl-image.waiting-for-permission #video-container {
		display: none;
	}
	.pl-image #prompt {
		display: none;
	}
	.pl-image.waiting-for-permission #prompt {
		width: 250px;
		height: 200px;
		display: grid;
		place-items: center;
		font-family: monospace;
		font-weight: bold;
		text-decoration: underline;
		cursor: pointer;
		border: 5px dashed rgba(0,0,0,.5);
	}

	.pl-image video {
		display: block;
	}
	.pl-image .bar {
		width: inherit;
		display: flex;
		z-index: 6;
	}
	.pl-image .bar#top {
		position: absolute;
		flex-direction: column;
	}
	
	.pl-image .bar#bottom {
		background: black;
		border-radius: 0 0 1rem 1rem;
	}
	.pl-image .bar button {
		flex: 0 0 auto;
		background: rgba(255,255,255,.8);
		border: none;
		width: 2rem;
		height: 2rem;
		border-radius: 100%;
		cursor: pointer;
		z-index: 7;
	}
	.pl-image .bar button#shutter {
		width: 3rem;
		height: 3rem;
		margin: -1.5rem auto .2rem auto;
	}

	.pl-image video.takepicture {
		animation: pictureflash 200ms linear;
	}

	@keyframes pictureflash {
		0% {
			filter: grayscale(1.0) contrast(2.0);
		}

		100% {
			filter: grayscale(0.0) contrast(1.0);
		}
	}
</style>

	<div id="video-container">
		<div id="top" class="bar">
			<button id="stop" title="Stop video">✖</button>
			<button id="pop-out" title="Pop out/pop in">⏏</button>
		</div>
		<video playsinline autoplay></video>
		<div id="bottom" class="bar">
		<button id="shutter" title="Click to take a picture">📷</button>
		</div>
	</div>
		
	<div id="prompt">
		<span>
		Enable webcam
		</span>
	</div>

<script>
	// based on https://github.com/fonsp/printi-static (by the same author)

	const span = currentScript.parentElement
	const video = span.querySelector("video")
	const popout = span.querySelector("button#pop-out")
	const stop = span.querySelector("button#stop")
	const shutter = span.querySelector("button#shutter")
	const prompt = span.querySelector(".pl-image #prompt")

	const maxsize = $(max_size)

	const send_source = (source, src_width, src_height) => {
		const scale = Math.min(1.0, maxsize / src_width, maxsize / src_height)

		const width = Math.floor(src_width * scale)
		const height = Math.floor(src_height * scale)

		const canvas = html`<canvas width=\${width} height=\${height}>`
		const ctx = canvas.getContext("2d")
		ctx.drawImage(source, 0, 0, width, height)

		span.value = {
			width: width,
			height: height,
			data: ctx.getImageData(0, 0, width, height).data,
		}
		span.dispatchEvent(new CustomEvent("input"))
	}
	
	const clear_camera = () => {
		window.stream.getTracks().forEach(s => s.stop());
		video.srcObject = null;

		span.classList.add("waiting-for-permission");
	}

	prompt.onclick = () => {
		navigator.mediaDevices.getUserMedia({
			audio: false,
			video: {
				facingMode: "environment",
			},
		}).then(function(stream) {

			stream.onend = console.log

			window.stream = stream
			video.srcObject = stream
			window.cameraConnected = true
			video.controls = false
			video.play()
			video.controls = false

			span.classList.remove("waiting-for-permission");

		}).catch(function(error) {
			console.log(error)
		});
	}
	stop.onclick = () => {
		clear_camera()
	}
	popout.onclick = () => {
		span.classList.toggle("popped-out")
	}

	shutter.onclick = () => {
		const cl = video.classList
		cl.remove("takepicture")
		void video.offsetHeight
		cl.add("takepicture")
		video.play()
		video.controls = false
		console.log(video)
		send_source(video, video.videoWidth, video.videoHeight)
	}
	
	
	document.addEventListener("visibilitychange", () => {
		if (document.visibilityState != "visible") {
			clear_camera()
		}
	})


	// Set a default image

	const img = html`<img crossOrigin="anonymous">`

	img.onload = () => {
	console.log("helloo")
		send_source(img, img.width, img.height)
	}
	img.src = "$(default_url)"
	console.log(img)
</script>
</span>
""" |> HTML
end

# ╔═╡ 20402780-426b-4caa-af8f-ff1e7787b7f9
@bind cam_data camera_input()

# ╔═╡ e15ad330-ee0d-11ea-25b6-1b1b3f3d7888

function process_raw_camera_data(raw_camera_data)
	# the raw image data is a long byte array, we need to transform it into something
	# more "Julian" - something with more _structure_.
	
	# The encoding of the raw byte stream is:
	# every 4 bytes is a single pixel
	# every pixel has 4 values: Red, Green, Blue, Alpha
	# (we ignore alpha for this notebook)
	
	# So to get the red values for each pixel, we take every 4th value, starting at 
	# the 1st:
	reds_flat = UInt8.(raw_camera_data["data"][1:4:end])
	greens_flat = UInt8.(raw_camera_data["data"][2:4:end])
	blues_flat = UInt8.(raw_camera_data["data"][3:4:end])
	
	# but these are still 1-dimensional arrays, nicknamed 'flat' arrays
	# We will 'reshape' this into 2D arrays:
	
	width = raw_camera_data["width"]
	height = raw_camera_data["height"]
	
	# shuffle and flip to get it in the right shape
	reds = reshape(reds_flat, (width, height))' / 255.0
	greens = reshape(greens_flat, (width, height))' / 255.0
	blues = reshape(blues_flat, (width, height))' / 255.0
	
	# we have our 2D array for each color
	# Let's create a single 2D array, where each value contains the R, G and B value of 
	# that pixel
	
	RGB.(reds, greens, blues)
end

# ╔═╡ ed9fb2ac-2680-42b7-9b00-591e45a5e105
cam_image = process_raw_camera_data(cam_data)

# ╔═╡ d38c6958-9300-4f7a-89cf-95ca9e899c13
mean_color(cam_image)

# ╔═╡ 82f1e006-60fe-4ad1-b9cb-180fafdeb4da
invert_image(cam_image)

# ╔═╡ 54c83589-b8c6-422a-b5e9-d8e0ee72a224
quantize(cam_image)

# ╔═╡ 18e781f8-66f3-4216-bc84-076a08f9f3fb
noisify(cam_image, .5)

# ╔═╡ ebf3193d-8c8d-4425-b252-45067a5851d9
[
	invert.(cam_image)      quantize(cam_image)
	noisify(cam_image, .5)  custom_filter(cam_image)
]

# ╔═╡ 8917529e-fa7a-412b-8aea-54f92f6270fa
custom_filter(cam_image)

# ╔═╡ 83eb9ca0-ed68-11ea-0bc5-99a09c68f867
md"_homework 1, version 7_"


