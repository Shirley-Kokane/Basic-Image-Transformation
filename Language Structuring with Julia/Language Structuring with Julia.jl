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

# ╔═╡ a4937996-f314-11ea-2ff9-615c888afaa8
begin
	using Pkg
	Pkg.activate(mktempdir())
	Pkg.add([
			Pkg.PackageSpec(name="Compose",version="0.9"),
			Pkg.PackageSpec(name="Colors",version="0.12"),
			Pkg.PackageSpec(name="PlutoUI",version="0.7"),
			])

	using Colors
	using PlutoUI
	using Compose
	using LinearAlgebra
end

# ╔═╡ 5756aa4b-74ec-4146-bd9d-65bf55a2c8ae
using DataFrames

# ╔═╡ 85cfbd10-f384-11ea-31dc-b5693630a4c5
md"""

# _Structure and Language_

This notebook contains _built-in, live answer checks_! In some exercises you will see a coloured box, which runs a test case on your code, and provides feedback based on the result. Simply edit the code, run it, and the check runs again.


"""

# ╔═╡ 938185ec-f384-11ea-21dc-b56b7469f798
md"""
#### Intializing packages
_When running this notebook for the first time, this could take up to 15 minutes. Hang in there!_
"""

# ╔═╡ c75856a8-1f36-4659-afb2-7edb14894ea1
md"""
## Introduction
"""

# ╔═╡ c9a8b35d-2183-4da1-ae35-d2552020e8a8
md"""
So far in the class the **data** that we have been dealing with has mainly been in the form of images. But, of course, we know that data comes in many other forms too, as we briefly discussed in the first lecture.

In this homework we will look at another very important data source: **written text** in **natural language**. (The word "natural" here is to distinguish human (natural) languages from computer languages.) 

We will both analyse actual text and try to generate random text that looks like natural language. Both the analysis and synthesis of natural language are key components of artificial intelligence and are the subject of [much current research](https://en.wikipedia.org/wiki/GPT-3).
"""

# ╔═╡ 6f9df800-f92d-11ea-2d49-c1aaabd2d012
md"""
##  _Language detection_

In this exercise we will create a very simple _Artificial Intelligence_. Natural language can be quite messy, but hidden in this mess is _structure_, which we will  look for today.

Let's start with some obvious structure in English text: the set of characters that we write the language in. If we generate random text by sampling (choosing) random characters (`Char` in Julia), it does not look like English:
"""

# ╔═╡ 3206c771-495a-43a9-b707-eaeb828a8545
rand(Char, 5)   # sample 5 random characters

# ╔═╡ b61722cc-f98f-11ea-22ae-d755f61f78c3
String(rand(Char, 40))   # join into a string

# ╔═╡ 59f2c600-2b64-4562-9426-2cfed9a864e4
md"""
[`Char` in Julia is the type for a [Unicode](https://en.wikipedia.org/wiki/Unicode) character, which includes characters like `日` and `⛄`.]
"""

# ╔═╡ f457ad44-f990-11ea-0e2d-2bb7627716a8
md"""
Instead, let's define an _alphabet_, and only use those letters to sample from. To keep things simple we will ignore punctuation, capitalization, etc., and use only the following 27 characters (English letters plus "space"):
"""

# ╔═╡ 4efc051e-f92e-11ea-080e-bde6b8f9295a
alphabet = ['a':'z' ; ' ']   # includes the space character

# ╔═╡ 38d1ace8-f991-11ea-0b5f-ed7bd08edde5
md"""
Let's sample random characters from our alphabet:
"""

# ╔═╡ ddf272c8-f990-11ea-2135-7bf1a6dca0b7
Text(String(rand(alphabet, 40)))

# ╔═╡ 3cc688d2-f996-11ea-2a6f-0b4c7a5b74c2
md"""
That already looks a lot better than our first attempt! But it still does not look like English text -- we can do better. 

### Frequency table

English words are not well modelled by this random-Latin-characters model. Our first observation is that **some letters are more common than others**. To put this observation into practice, we would like to have the **frequency table** of the Latin alphabet. We could search for it online, but it is actually very simple to calculate ourselves! The only thing we need is a _representative sample_ of English text.

The following samples are from Wikipedia, but feel free to type in your own sample! You can also enter a sample of a different language, if that language can be expressed in the Latin alphabet.

Remember that the $(html"<img src='https://cdn.jsdelivr.net/gh/ionic-team/ionicons@5.0.0/src/svg/eye-outline.svg' style='width: 1em; height: 1em; margin-bottom: -.2em;'>") button on the left of a cell will show or hide the code.

We also include a sample of Spanish, which we'll use later!
"""

# ╔═╡ a094e2ac-f92d-11ea-141a-3566552dd839
md"""
#### _Data cleaning_
Looking at the sample, we see that it is quite _messy_: it contains punctuation, accented letters and numbers. For our analysis, we are only interested in our 27-character alphabet (i.e. `'a'` through `'z'` plus `' '`). We are going to clean the data using the Julia function `filter`. 
"""

# ╔═╡ 27c9a7f4-f996-11ea-1e46-19e3fc840ad9
filter(isodd, [6, 7, 8, 9, -5])

# ╔═╡ f2a4edfa-f996-11ea-1a24-1ba78fd92233
md"""
`filter` takes two arguments: a **function** and a **collection**. The function is applied to each element of the collection, and it must return either `true` or `false` for each element. [Such a function is often called a **predicate**.] If the result is `true`, then that element is included in the final collection.

Did you notice something cool? Functions are also just _objects_ in Julia, and you can use them as arguments to other functions! _(Fons thinks this is super cool.)_

$(html"<br>")

We have written a function `isinalphabet`, which takes a character and returns a boolean:
"""

# ╔═╡ 5c74a052-f92e-11ea-2c5b-0f1a3a14e313
function isinalphabet(character)
	character ∈ alphabet
end

# ╔═╡ dcc4156c-f997-11ea-3e6f-057cd080d9db
isinalphabet('a'), isinalphabet('+')

# ╔═╡ 129fbcfe-f998-11ea-1c96-0fd3ccd2dcf8
md"👉 Use `filter` to extract just the characters from our alphabet out of `messy_sentence_1`:"

# ╔═╡ 3a5ee698-f998-11ea-0452-19b70ed11a1d
messy_sentence_1 = "#wow 2020 ¥500 (blingbling!)"

# ╔═╡ 75694166-f998-11ea-0428-c96e1113e2a0
cleaned_sentence_1 = filter(isinalphabet, messy_sentence_1)

# ╔═╡ 05f0182c-f999-11ea-0a52-3d46c65a049e
md"""
$(html"<br>")

We are not interested in the capitalization of letters (i.e. `'A'` vs `'a'`), so we want to *map* these to lower case _before_ we apply our filter. If we don't, all upper case letters would get deleted.

Julia has a `map` function to do exactly this. Like `filter`, its first argument is the function we want to map over the vector in the second argument.

"""

# ╔═╡ 98266882-f998-11ea-3270-4339fb502bc7
md"👉 Use the function `lowercase` to convert `messy_sentence_2` into a lower case string, and then use `filter` to extract only the characters from our alphabet."

# ╔═╡ d3c98450-f998-11ea-3caf-895183af926b
messy_sentence_2 = "Awesome! 😍"

# ╔═╡ d3a4820e-f998-11ea-2a5c-1f37e2a6dd0a
cleaned_sentence_2 = filter(isinalphabet, map(lowercase, messy_sentence_2))

# ╔═╡ aad659b8-f998-11ea-153e-3dae9514bfeb
md"""
$(html"<br>")

Finally, we need to deal with **accents**: simply deleting accented characters from the source text might deform it too much. We can add accented letters to our alphabet, but a simpler solution is to *replace* accented letters with the corresponding unaccented base character. We have written a function `unaccent` that does just that.
"""

# ╔═╡ d236b51e-f997-11ea-0c55-abb11eb35f4d
french_word = "Égalité!"

# ╔═╡ 24860970-fc48-11ea-0009-cddee695772c
import Unicode

# ╔═╡ 734851c6-f92d-11ea-130d-bf2a69e89255
"""
Turn `"áéíóúüñ asdf"` into `"aeiouun asdf"`.
"""
unaccent(str) = Unicode.normalize(str, stripmark=true)

# ╔═╡ d67034d0-f92d-11ea-31c2-f7a38ebb412f
samples = (
	English = """
Although the word forest is commonly used, there is no universally recognised precise definition, with more than 800 definitions of forest used around the world.[4] Although a forest is usually defined by the presence of trees, under many definitions an area completely lacking trees may still be considered a forest if it grew trees in the past, will grow trees in the future,[9] or was legally designated as a forest regardless of vegetation type.[10][11]
	
The word forest derives from the Old French forest (also forès), denoting "forest, vast expanse covered by trees"; forest was first introduced into English as the word denoting wild land set aside for hunting[14] without the necessity in definition of having trees on the land.[15] Possibly a borrowing, probably via Frankish or Old High German, of the Medieval Latin foresta, denoting "open wood", Carolingian scribes first used foresta in the Capitularies of Charlemagne specifically to denote the royal hunting grounds of the King. The word was not endemic to Romance languages, e. g. native words for forest in the Romance languages derived from the Latin silva, which denoted "forest" and "wood(land)" (confer the English sylva and sylvan); confer the Italian, Spanish, and Portuguese selva; the Romanian silvă; and the Old French selve, and cognates in Romance languages, e. g. the Italian foresta, Spanish and Portuguese floresta, etc., are all ultimately derivations of the French word. 
""",
	Spanish =  """
Un bosque es un ecosistema donde la vegetación predominante la constituyen los árboles y matas.1​ Estas comunidades de plantas cubren grandes áreas del globo terráqueo y funcionan como hábitats para los animales, moduladores de flujos hidrológicos y conservadores del suelo, constituyendo uno de los aspectos más importantes de la biosfera de la Tierra. Aunque a menudo se han considerado como consumidores de dióxido de carbono atmosférico, los bosques maduros son prácticamente neutros en cuanto al carbono, y son solamente los alterados y los jóvenes los que actúan como dichos consumidores.2​3​ De cualquier manera, los bosques maduros juegan un importante papel en el ciclo global del carbono, como reservorios estables de carbono y su eliminación conlleva un incremento de los niveles de dióxido de carbono atmosférico.

Los bosques pueden hallarse en todas las regiones capaces de mantener el crecimiento de árboles, hasta la línea de árboles, excepto donde la frecuencia de fuego natural es demasiado alta, o donde el ambiente ha sido perjudicado por procesos naturales o por actividades humanas. Los bosques a veces contienen muchas especies de árboles dentro de una pequeña área (como la selva lluviosa tropical y el bosque templado caducifolio), o relativamente pocas especies en áreas grandes (por ejemplo, la taiga y bosques áridos montañosos de coníferas). Los bosques son a menudo hogar de muchos animales y especies de plantas, y la biomasa por área de unidad es alta comparada a otras comunidades de vegetación. La mayor parte de esta biomasa se halla en el subsuelo en los sistemas de raíces y como detritos de plantas parcialmente descompuestos. El componente leñoso de un bosque contiene lignina, cuya descomposición es relativamente lenta comparado con otros materiales orgánicos como la celulosa y otros carbohidratos. Los bosques son áreas naturales y silvestre 
""" |> unaccent,
)

# ╔═╡ a56724b6-f9a0-11ea-18f2-991e0382eccf
unaccent(french_word)

# ╔═╡ 8d3bc9ea-f9a1-11ea-1508-8da4b7674629
md"""
$(html"<br>")

👉 Let's put everything together. Write a function `clean` that takes a string, and returns a _cleaned_ version, where:
- accented letters are replaced by their base characters;
- upper-case letters are converted to lower case;
- it is filtered to only contain characters from `alphabet`
"""

# ╔═╡ 4affa858-f92e-11ea-3ece-258897c37e51
function clean(text)
	
	return filter(isinalphabet, map(lowercase, unaccent(text)))
end

# ╔═╡ e00d521a-f992-11ea-11e0-e9da8255b23b
clean("Crème brûlée est mon plat préféré.")

# ╔═╡ 2680b506-f9a3-11ea-0849-3989de27dd9f
first_sample = clean(first(samples))

# ╔═╡ 571d28d6-f960-11ea-1b2e-d5977ecbbb11
function letter_frequencies(txt)
	ismissing(txt) && return missing
	f = count.(string.(alphabet), txt)
	f ./ sum(f)
end

# ╔═╡ 11e9a0e2-bc3d-4130-9a73-7c2003595caa
alphabet

# ╔═╡ 6a64ab12-f960-11ea-0d92-5b88943cdb1a
sample_freqs = letter_frequencies(first_sample)

# ╔═╡ 603741c2-f9a4-11ea-37ce-1b36ecc83f45
md"""
The result is a 27-element array, with values between `0.0` and `1.0`. These values correspond to the _frequency_ of each letter. 

`sample_freqs[i] == 0.0` means that the $i$th letter did not occur in your sample, and 
`sample_freqs[i] == 0.1` means that 10% of the letters in the sample are the $i$th letter.

To make it easier to convert between a character from the alphabet and its index, we have the following function:
"""

# ╔═╡ b3de6260-f9a4-11ea-1bae-9153a92c3fe5
index_of_letter(letter) = findfirst(isequal(letter), alphabet)

# ╔═╡ a6c36bd6-f9a4-11ea-1aba-f75cecc90320
index_of_letter('a'), index_of_letter('b'), index_of_letter(' ')

# ╔═╡ 6d3f9dae-f9a5-11ea-3228-d147435e266d
md"""
$(html"<br>")

👉 Which letters from the alphabet did not occur in the sample?
"""

# ╔═╡ 92bf9fd2-f9a5-11ea-25c7-5966e44db6c6
begin 
	unused_letters = []
	for i in 1: length(sample_freqs)
		if  iszero(sample_freqs[i])
			push!(unused_letters, alphabet[i])
		end
	end
	println(unused_letters)
end

#unused_letters = [ifelse(iszero(sample_freqs), , 'c'] # replace with your answer

# ╔═╡ 01215e9a-f9a9-11ea-363b-67392741c8d4
md"""
**Random letters at the correct frequencies:**
"""

# ╔═╡ 8ae13cf0-f9a8-11ea-3919-a735c4ed9e7f
md"""
By considering the _frequencies_ of letters in English, we see that our model is already a lot better! 

Our next observation is that **some letter _combinations_ are more common than others**. Our current model thinks that `potato` is just as 'English' as `ooaptt`. In the next section, we will quantify these _transition frequencies_, and use it to improve our model.
"""

# ╔═╡ 343d63c2-fb58-11ea-0cce-efe1afe070c2


# ╔═╡ b5b8dd18-f938-11ea-157b-53b145357fd1
function rand_sample(frequencies)
	x = rand()
	findfirst(z -> z >= x, cumsum(frequencies ./ sum(frequencies)))
end

# ╔═╡ 0e872a6c-f937-11ea-125e-37958713a495
function rand_sample_letter(frequencies)
	alphabet[rand_sample(frequencies)]
end

# ╔═╡ fbb7c04e-f92d-11ea-0b81-0be20da242c8
function transition_counts(cleaned_sample)
	[count(string(a, b), cleaned_sample)
		for a in alphabet,
			b in alphabet]
end

# ╔═╡ 80118bf8-f931-11ea-34f3-b7828113ffd8
normalize_array(x) = x ./ sum(x)

# ╔═╡ 7f4f6ce4-f931-11ea-15a4-b3bec6a7e8b6
transition_frequencies = normalize_array ∘ transition_counts;

# ╔═╡ d40034f6-f9ab-11ea-3f65-7ffd1256ae9d
transition_frequencies(first_sample)

# ╔═╡ 689ed82a-f9ae-11ea-159c-331ff6660a75
md"What we get is a **27 by 27 matrix**. Each entry corresponds to a character pair. The _row_ corresponds to the first character, the _column_ is the second character. Let's visualize this:"

# ╔═╡ aa2a73f6-0c1d-4be1-a414-05a6f8ce04bd
md"""
The brightness of each letter pair indicates how frequent that pair is; here space is indicated as `_`.
"""

# ╔═╡ 0b67789c-f931-11ea-113c-35e5edafcbbf
md"""
Answer the following questions with respect to the **cleaned English sample text**, which we called `first_sample`. Let's also give the transition matrix a name:
"""

# ╔═╡ 6896fef8-f9af-11ea-0065-816a70ba9670
sample_freq_matrix = transition_frequencies(first_sample);

# ╔═╡ 39152104-fc49-11ea-04dd-bb34e3600f2f
if first_sample === missing
	md"""
	!!! danger "Don't worry!"
	    👆 These errors will disappear automatically once you have completed the earlier exercises!
	"""
end

# ╔═╡ e91c6fd8-f930-11ea-01ac-476bbde79079
md"""👉 What is the frequency of the combination `"th"`?"""

# ╔═╡ 1b4c0c28-f9ab-11ea-03a6-69f69f7f90ed
th_frequency = sample_freq_matrix[index_of_letter('t'), index_of_letter('h')]

# ╔═╡ 1f94e0a2-f9ab-11ea-1347-7dd906ebb09d
md"""👉 What about `"ht"`?"""

# ╔═╡ 41b2df7c-f931-11ea-112e-ede3b16f357a
ht_frequency = sample_freq_matrix[index_of_letter('h'), index_of_letter('t')]

# ╔═╡ 1dd1e2f4-f930-11ea-312c-5ff9e109c7f6
md"""
👉 Write code to find which le**tt**ers appeared doubled in our sample.
"""

# ╔═╡ 65c92cac-f930-11ea-20b1-6b8f45b3f262
double_letters = (alphabet[diag(sample_freq_matrix) .!= 0 ])# replace with your answer

# ╔═╡ 4582ebf4-f930-11ea-03b2-bf4da1a8f8df
md"""
👉 Which letter is most likely to follow a **W**?

_You are free to do this partially by hand, partially using code, whatever is easiest!_
"""

# ╔═╡ 7898b76a-f930-11ea-2b7e-8126ec2b8ffd
begin 
	a = argmax(sample_freq_matrix[index_of_letter('w'),:]) 
	for i in 1:27
		if sample_freq_matrix[index_of_letter('w'),i] == a
			most_likely_to_follow_w = alphabet[i]
			println(most_likely_to_follow_w)
		end
	end
end

 # replace with your answer

# ╔═╡ c04b4c88-64ba-4180-91f3-5ab183397405
most_likely_to_follow_w = alphabet[map(alphabet) do c
			sample_freq_matrix[index_of_letter('w'), index_of_letter(c)]
				end |> argmax #==#]

# ╔═╡ 458cd100-f930-11ea-24b8-41a49f6596a0
md"""
👉 Which letter is most likely to precede a **W**?

_You are free to do this partially by hand, partially using code, whatever is easiest!_
"""

# ╔═╡ bc401bee-f931-11ea-09cc-c5efe2f11194
most_likely_to_precede_w = alphabet[map(alphabet) do k
		sample_freq_matrix[index_of_letter(k), index_of_letter('w')]
	end |> argmax ]# replace with your answer

# ╔═╡ 45c20988-f930-11ea-1d12-b782d2c01c11
md"""
👉 What is the sum of each row? What is the sum of each column? What is the sum of the matrix? How can we interpret these values?"
"""

# ╔═╡ 4f8b1f0c-9dc4-4b13-8e96-b30d13c85d36
row_sums= Float64[0]

# ╔═╡ 269dd618-3c39-4b48-ba97-0a6f76d00c9b
Row = [sum(sample_freq_matrix[1,:])]

# ╔═╡ 48f44d73-cfdd-4630-8281-738bbaed3b9c
begin
	t = length(sample_freq_matrix[:,1])
	for k in 1:t
		Row = [sum(sample_freq_matrix[k,:])]
		append!(row_sums, Row)
	end
end

# ╔═╡ 58428158-84ac-44e4-9b38-b991728cd98a
Row

# ╔═╡ 9979ebaf-5cd9-4695-b8a5-6b45c78b3fa0


# ╔═╡ c4a7bdf8-315d-4a57-a005-83a66419a507
begin
	col_sums = Float64[0]
	til = length(sample_freq_matrix[1,:])
	for k in 1:til
		Row = [sum(sample_freq_matrix[:,k])]
		append!(col_sums, Row)
	end
end

# ╔═╡ 4a0314a6-7dc0-4ee9-842b-3f9bd4d61fb1
length(col_sums)

# ╔═╡ cc62929e-f9af-11ea-06b9-439ac08dcb52
row_col_answer = sum(row_sums + col_sums)

# ╔═╡ 2f8dedfc-fb98-11ea-23d7-2159bdb6a299
md"""
We can use the measured transition frequencies to generate text in a way that it has **the same transition frequencies** as our original sample. Our generated text is starting to look like real language!
"""

# ╔═╡ b7446f34-f9b1-11ea-0f39-a3c17ba740e5
@bind ex23_sample Select([v => String(k) for (k,v) in zip(fieldnames(typeof(samples)), samples)])

# ╔═╡ 4f97b572-f9b0-11ea-0a99-87af0797bf28
md"""
**Random letters from the alphabet:**
"""

# ╔═╡ 4e8d327e-f9b0-11ea-3f16-c178d96d07d9
md"""
**Random letters at the correct frequencies:**
"""

# ╔═╡ d83f8bbc-f9af-11ea-2392-c90e28e96c65
md"""
**Random letters at the correct transition frequencies:**
"""

# ╔═╡ 0e465160-f937-11ea-0ebb-b7e02d71e8a8
function sample_text(A, n)
	
	first_index = rand_sample(vec(sum(A, dims=1)))
	
	indices = reduce(1:n; init=[first_index]) do word, _
		prev = last(word)
		freq = normalize_array(A[prev, :])
		next = rand_sample(freq)
		[word..., next]
	end
	
	String(alphabet[indices])
end

# ╔═╡ 141af892-f933-11ea-1e5f-154167642809
md"""
It looks like we have a decent language model, in the sense that it understands _transition frequencies_ in the language. In the demo above, try switching the language between $(join(string.(fieldnames(typeof(samples))), " and ")) -- the generated text clearly looks more like one or the other, demonstrating that the model can capture differences between the two languages. What's remarkable is that our "training data" was just a single paragraph per language.

In this exercise, we will use our model to write a **classifier**: a program that automatically classifies a text as either $(join(string.(fieldnames(typeof(samples))), " or ")). 

This is not a difficult task -- you can download dictionaries for both languages, and count matches -- but we are doing something much more exciting: we only use a single paragraph of each language, and we use a _language model_ as classifier.
"""

# ╔═╡ 7eed9dde-f931-11ea-38b0-db6bfcc1b558
html"<h4 id='mystery-detect'>Mystery sample</h4>
<p>Enter some text here -- we will detect in which language it is written!</p>" # dont delete me

# ╔═╡ 7e3282e2-f931-11ea-272f-d90779264456
@bind mystery_sample TextField((70,8), default="""
Small boats are typically found on inland waterways such as rivers and lakes, or in protected coastal areas. However, some boats, such as the whaleboat, were intended for use in an offshore environment. In modern naval terms, a boat is a vessel small enough to be carried aboard a ship. Anomalous definitions exist, as lake freighters 1,000 feet (300 m) long on the Great Lakes are called "boats". 
""")

# ╔═╡ 7df55e6c-f931-11ea-33b8-fdc3be0b6cfa
mystery_sample

# ╔═╡ 292e0384-fb57-11ea-0238-0fbe416fc976
md"""
Let's compute the transition frequencies of our mystery sample! Type some text in the box above, and check whether the frequency matrix updates.
"""

# ╔═╡ 7dabee08-f931-11ea-0cb2-c7d5afd21551
transition_frequencies(mystery_sample)

# ╔═╡ 3736a094-fb57-11ea-1d39-e551aae62b1d
md"""
Our model will **compare the transition frequencies of our mystery sample** to those of our two language samples. The closest match will be our detected language.

The only question left is: How do we compare two matrices? When two matrices are almost equal, but not exactly, we want to quantify the _distance_ between them.

👉 Write a function called `matrix_distance` which takes 2 matrices of the same size and finds the distance between them by:

1. Subtracting corresponding elements
2. Finding the absolute value of the difference
3. Summing the differences
"""

# ╔═╡ 13c89272-f934-11ea-07fe-91b5d56dedf8
function matrix_distance(A, B)
	distances = abs.(A.-B) #matrix_distance(A,B)

	return sum(distances) # do something with A .- B
end

# ╔═╡ 7d60f056-f931-11ea-39ae-5fa18a955a77
distances = map(samples) do sample
	matrix_distance(transition_frequencies(mystery_sample), transition_frequencies(sample))
end

# ╔═╡ 7d1439e6-f931-11ea-2dab-41c66a779262
try
	@assert !ismissing(distances.English)
	"""<h2>It looks like this text is *$(argmin(distances))*!</h2>""" |> HTML
catch
end

# ╔═╡ 82e0df62-fb54-11ea-3fff-b16c87a7d45b
md"""
## _Language generation_

Our model from Exercise 1 has the property that it can easily be 'reversed' to _generate_ text. While this is useful to demonstrate its structure, the produced text is mostly meaningless: it fails to model words, let alone sentence structure.

To take our model one step further, we are going to _generalize_ what we have done so far. Instead of looking at _letter combinations_, we will model _word combinations_.  And instead of analyzing the frequencies of bigrams (combinations of two letters), we are going to analyze _$n$-grams_.

#### Dataset
This also means that we are going to need a larger dataset to train our model on: the number of English words (and their combinations) is much higher than the number of letters.

We will train our model on the novel [_Emma_ (1815), by Jane Austen](https://en.wikipedia.org/wiki/Emma_(novel)). This work is in the public domain, which means that we can download the whole book as a text file from `archive.org`. We've done the process of downloading and cleaning already, and we have split the text into word and punctuation tokens.
"""

# ╔═╡ b7601048-fb57-11ea-0754-97dc4e0623a1
emma = let
	raw_text = read(download("https://ia800303.us.archive.org/24/items/EmmaJaneAusten_753/emma_pdf_djvu.txt"), String)
	
	first_words = "Emma Woodhouse"
	last_words = "THE END"
	start_index = findfirst(first_words, raw_text)[1]
	stop_index = findlast(last_words, raw_text)[end]
	
	raw_text[start_index:stop_index]
end;

# ╔═╡ cc42de82-fb5a-11ea-3614-25ef961729ab
function splitwords(text)
	# clean up whitespace
	cleantext = replace(text, r"\s+" => " ")
	
	# split on whitespace or other word boundaries
	tokens = split(cleantext, r"(\s|\b)")
end

# ╔═╡ d66fe2b2-fb5a-11ea-280f-cfb12b8296ac
emma_words = splitwords(emma)

# ╔═╡ 4ca8e04a-fb75-11ea-08cc-2fdef5b31944
forest_words = splitwords(samples.English)

# ╔═╡ 6f613cd2-fb5b-11ea-1669-cbd355677649
md"""
#### _bigrams revisited_

The goal of the upcoming exercises is to **generalize** what we have done in Exercise 1. To keep things simple, we _split up our problem_ into smaller problems. (The solution to any computational problem.)

First, here is a function that takes an array, and returns the array of all **neighbour pairs** from the original. For example,

```julia
bigrams([1, 2, 3, 42])
```
gives

```julia
[[1,2], [2,3], [3,42]]
```

(We used integers as "words" in this example, but our function works with any type of word.)
"""

# ╔═╡ 91e87974-fb78-11ea-3ce4-5f64e506b9d2
function bigrams(words)
	starting_positions = 1:length(words)-1
	
	map(starting_positions) do i
		words[i:i+1]
	end
end

# ╔═╡ 9f98e00e-fb78-11ea-0f6c-01206e7221d6
bigrams([1, 2, 3, 42])

# ╔═╡ d7d8cd0c-fb6a-11ea-12bf-2d1448b38162
md"""
👉 Next, it's your turn to write a more general function `ngrams` that takes an array and a number $n$, and returns all **subsequences of length $n$**. For example:

```julia
ngrams([1, 2, 3, 42], 3)
```
should give

```julia
[[1,2,3], [2,3,42]]
```

and

```julia
ngrams([1, 2, 3, 42], 2) == bigrams([1, 2, 3, 42])
```
"""

# ╔═╡ 7be98e04-fb6b-11ea-111d-51c48f39a4e9
function ngrams(words, n)
	start_pos = 1:length(words) - n +1
	
	map(start_pos) do i 
		words[i:i+n-1]
	
	end
end

# ╔═╡ 052f822c-fb7b-11ea-382f-af4d6c2b4fdb
ngrams([1, 2, 3, 42], 3)

# ╔═╡ 067f33fc-fb7b-11ea-352e-956c8727c79f
ngrams(forest_words, 4)

# ╔═╡ 7b10f074-fb7c-11ea-20f0-034ddff41bc3
md"""
If you are stuck, you can write `ngrams(words, n) = bigrams(words)` (ignoring the true value of $n$), and continue with the other exercises.

#### _frequency matrix revisisted_
In  1 we use a 2D array to store the bigram frequencies, where each column or row corresponds to a character from the alphabet. To use trigrams we could store the frequencies in a 3D array, and so on. 

However, when counting words instead of letters we run into a problem: A 3D array with one row, column and layer per word has too many elements to store on our computer!
"""

# ╔═╡ 24ae5da0-fb7e-11ea-3480-8bb7b649abd5
md"""
_Emma_ consists of $(
	length(Set(emma_words))
) unique words. This means that there are $(
	Int(floor(length(Set(emma_words))^3 / 10^9))
) billion possible trigrams - that's too many!
"""

# ╔═╡ 47836744-fb7e-11ea-2305-3fa5819dc154
md"""
$(html"<br>")

Although the frequency array would be very large, *most entries are zero*. For example, _"Emma"_ is a common word, but the sequence of words _"Emma Emma Emma"_ never occurs in the novel. We  about the  _sparsity_ of the non-zero entries in a matrix. When a matrix is sparse in this way, we can **store the same information in a more efficient structure**. 

Julia's [`SparseArrays.jl` package](https://docs.julialang.org/en/v1/stdlib/SparseArrays/index.html) might sound like a logical choice, but the arrays from that package support only 1D and 2D types, and we also want to directly index using strings, not just integers. So instead we will use a **dictionary**, or `Dict` in Julia.

Take a close look at the next example. Note that you can click on the output to expand the data viewer.
"""

# ╔═╡ df4fc31c-fb81-11ea-37b3-db282b36f5ef
healthy = Dict("fruits" => ["🍎", "🍊"], "vegetables" => ["🌽", "🎃", "🍕"])

# ╔═╡ c83b1770-fb82-11ea-20a6-3d3a09606c62
healthy["fruits"]

# ╔═╡ 52970ac4-fb82-11ea-3040-8bd0590348d2
md"""
(Did you notice something funny? The dictionary is _unordered_, this is why the entries were printed in reverse from the definition.)

You can dynamically add or change values of a `Dict` by assigning to `my_dict[key]`. You can check whether a key already exists using `haskey(my_dict, key)`.

👉 Use these two techniques to write a function `word_counts` that takes an array of words, and returns a `Dict` with entries `word => number_of_occurences`.

For example:
```julia
word_counts(["to", "be", "or", "not", "to", "be"])
```
should return
```julia
Dict(
	"to" => 2, 
	"be" => 2, 
	"or" => 1, 
	"not" => 1
)
```
"""

# ╔═╡ 6b4d6584-f3be-11ea-131d-e5bdefcc791b
md"## Function library

Just some helper functions used in the notebook."

# ╔═╡ 54b1e236-fb53-11ea-3769-b382ef8b25d6
function Quote(text::AbstractString)
	text |> Markdown.Paragraph |> Markdown.BlockQuote |> Markdown.MD
end

# ╔═╡ 7e09011c-71b5-4f05-ae4a-025d48daca1d
samples.English |> Quote

# ╔═╡ ddef9c94-fb96-11ea-1f17-f173a4ff4d89
function compimg(img, labels=[c*d for c in replace(alphabet, ' ' => "_"), d in replace(alphabet, ' ' => "_")])
	xmax, ymax = size(img)
	xmin, ymin = 0, 0
	arr = [(j-1, i-1) for i=1:ymax, j=1:xmax]

	compose(context(units=UnitBox(xmin, ymin, xmax, ymax)),
		fill(vec(img)),
		compose(context(),
			fill("white"), font("monospace"), 
			text(first.(arr) .+ .1, last.(arr) .+ 0.6, labels)),
		rectangle(
			first.(arr),
			last.(arr),
			fill(1.0, length(arr)),
			fill(1.0, length(arr))))
end

# ╔═╡ b7803a28-fb96-11ea-3e30-d98eb322d19a
function show_pair_frequencies(A)
	imshow = let
		to_rgb(x) = RGB(0.36x, 0.82x, 0.8x)
		to_rgb.(A ./ maximum(abs.(A)))
	end
	compimg(imshow)
end

# ╔═╡ ace3dc76-f9ae-11ea-2bee-3d0bfa57cfbc
show_pair_frequencies(transition_frequencies(first_sample))

# ╔═╡ ffc17f40-f380-11ea-30ee-0fe8563c0eb1
hint(text) = Markdown.MD(Markdown.Admonition("hint", "Hint", [text]))

# ╔═╡ ffc40ab2-f380-11ea-2136-63542ff0f386
almost(text) = Markdown.MD(Markdown.Admonition("warning", "Almost there!", [text]))

# ╔═╡ ffceaed6-f380-11ea-3c63-8132d270b83f
still_missing(text=md"Replace `missing` with your answer.") = Markdown.MD(Markdown.Admonition("warning", "Here we go!", [text]))

# ╔═╡ ffde44ae-f380-11ea-29fb-2dfcc9cda8b4
keep_working(text=md"The answer is not quite right.") = Markdown.MD(Markdown.Admonition("danger", "Keep working on it!", [text]))

# ╔═╡ ffe326e0-f380-11ea-3619-61dd0592d409
yays = [md"Fantastic!", md"Splendid!", md"Great!", md"Yay ❤", md"Great! 🎉", md"Well done!", md"Keep it up!", md"Good job!", md"Awesome!", md"You got the right answer!", md"Let's move on to the next section."]

# ╔═╡ fff5aedc-f380-11ea-2a08-99c230f8fa32
correct(text=rand(yays)) = Markdown.MD(Markdown.Admonition("correct", "Got it!", [text]))

# ╔═╡ 00026442-f381-11ea-2b41-bde1fff66011
not_defined(variable_name) = Markdown.MD(Markdown.Admonition("danger", "Oopsie!", [md"Make sure that you define a variable called **$(Markdown.Code(string(variable_name)))**"]))

# ╔═╡ 20c0bfc0-a6ce-4290-95e1-d01264114cb1
todo(text) = HTML("""<div
	style="background: rgb(220, 200, 255); padding: 2em; border-radius: 1em;"
	><h1>TODO</h1>$(repr(MIME"text/html"(), text))</div>""")

# ╔═╡ 00115b6e-f381-11ea-0bc6-61ca119cb628
bigbreak = html"<br><br><br><br><br>";

# ╔═╡ d3d7bd9c-f9af-11ea-1570-75856615eb5d
bigbreak

# ╔═╡ Cell order:
# ╟─85cfbd10-f384-11ea-31dc-b5693630a4c5
# ╟─938185ec-f384-11ea-21dc-b56b7469f798
# ╠═a4937996-f314-11ea-2ff9-615c888afaa8
# ╟─c75856a8-1f36-4659-afb2-7edb14894ea1
# ╟─c9a8b35d-2183-4da1-ae35-d2552020e8a8
# ╟─6f9df800-f92d-11ea-2d49-c1aaabd2d012
# ╠═3206c771-495a-43a9-b707-eaeb828a8545
# ╠═b61722cc-f98f-11ea-22ae-d755f61f78c3
# ╟─59f2c600-2b64-4562-9426-2cfed9a864e4
# ╟─f457ad44-f990-11ea-0e2d-2bb7627716a8
# ╠═4efc051e-f92e-11ea-080e-bde6b8f9295a
# ╟─38d1ace8-f991-11ea-0b5f-ed7bd08edde5
# ╠═ddf272c8-f990-11ea-2135-7bf1a6dca0b7
# ╟─3cc688d2-f996-11ea-2a6f-0b4c7a5b74c2
# ╟─d67034d0-f92d-11ea-31c2-f7a38ebb412f
# ╟─7e09011c-71b5-4f05-ae4a-025d48daca1d
# ╟─a094e2ac-f92d-11ea-141a-3566552dd839
# ╠═27c9a7f4-f996-11ea-1e46-19e3fc840ad9
# ╟─f2a4edfa-f996-11ea-1a24-1ba78fd92233
# ╟─5c74a052-f92e-11ea-2c5b-0f1a3a14e313
# ╠═dcc4156c-f997-11ea-3e6f-057cd080d9db
# ╟─129fbcfe-f998-11ea-1c96-0fd3ccd2dcf8
# ╠═3a5ee698-f998-11ea-0452-19b70ed11a1d
# ╠═75694166-f998-11ea-0428-c96e1113e2a0
# ╟─05f0182c-f999-11ea-0a52-3d46c65a049e
# ╟─98266882-f998-11ea-3270-4339fb502bc7
# ╠═d3c98450-f998-11ea-3caf-895183af926b
# ╠═d3a4820e-f998-11ea-2a5c-1f37e2a6dd0a
# ╟─aad659b8-f998-11ea-153e-3dae9514bfeb
# ╠═d236b51e-f997-11ea-0c55-abb11eb35f4d
# ╠═a56724b6-f9a0-11ea-18f2-991e0382eccf
# ╟─24860970-fc48-11ea-0009-cddee695772c
# ╟─734851c6-f92d-11ea-130d-bf2a69e89255
# ╟─8d3bc9ea-f9a1-11ea-1508-8da4b7674629
# ╠═4affa858-f92e-11ea-3ece-258897c37e51
# ╠═e00d521a-f992-11ea-11e0-e9da8255b23b
# ╠═2680b506-f9a3-11ea-0849-3989de27dd9f
# ╟─571d28d6-f960-11ea-1b2e-d5977ecbbb11
# ╠═11e9a0e2-bc3d-4130-9a73-7c2003595caa
# ╠═6a64ab12-f960-11ea-0d92-5b88943cdb1a
# ╟─603741c2-f9a4-11ea-37ce-1b36ecc83f45
# ╟─b3de6260-f9a4-11ea-1bae-9153a92c3fe5
# ╠═a6c36bd6-f9a4-11ea-1aba-f75cecc90320
# ╟─6d3f9dae-f9a5-11ea-3228-d147435e266d
# ╠═92bf9fd2-f9a5-11ea-25c7-5966e44db6c6
# ╟─01215e9a-f9a9-11ea-363b-67392741c8d4
# ╟─8ae13cf0-f9a8-11ea-3919-a735c4ed9e7f
# ╟─343d63c2-fb58-11ea-0cce-efe1afe070c2
# ╟─b5b8dd18-f938-11ea-157b-53b145357fd1
# ╟─0e872a6c-f937-11ea-125e-37958713a495
# ╠═fbb7c04e-f92d-11ea-0b81-0be20da242c8
# ╠═80118bf8-f931-11ea-34f3-b7828113ffd8
# ╠═7f4f6ce4-f931-11ea-15a4-b3bec6a7e8b6
# ╠═d40034f6-f9ab-11ea-3f65-7ffd1256ae9d
# ╟─689ed82a-f9ae-11ea-159c-331ff6660a75
# ╠═ace3dc76-f9ae-11ea-2bee-3d0bfa57cfbc
# ╟─aa2a73f6-0c1d-4be1-a414-05a6f8ce04bd
# ╟─0b67789c-f931-11ea-113c-35e5edafcbbf
# ╠═6896fef8-f9af-11ea-0065-816a70ba9670
# ╟─39152104-fc49-11ea-04dd-bb34e3600f2f
# ╟─e91c6fd8-f930-11ea-01ac-476bbde79079
# ╠═1b4c0c28-f9ab-11ea-03a6-69f69f7f90ed
# ╟─1f94e0a2-f9ab-11ea-1347-7dd906ebb09d
# ╠═41b2df7c-f931-11ea-112e-ede3b16f357a
# ╟─1dd1e2f4-f930-11ea-312c-5ff9e109c7f6
# ╠═65c92cac-f930-11ea-20b1-6b8f45b3f262
# ╟─4582ebf4-f930-11ea-03b2-bf4da1a8f8df
# ╠═7898b76a-f930-11ea-2b7e-8126ec2b8ffd
# ╠═c04b4c88-64ba-4180-91f3-5ab183397405
# ╟─458cd100-f930-11ea-24b8-41a49f6596a0
# ╠═bc401bee-f931-11ea-09cc-c5efe2f11194
# ╟─45c20988-f930-11ea-1d12-b782d2c01c11
# ╠═5756aa4b-74ec-4146-bd9d-65bf55a2c8ae
# ╠═4f8b1f0c-9dc4-4b13-8e96-b30d13c85d36
# ╠═269dd618-3c39-4b48-ba97-0a6f76d00c9b
# ╠═48f44d73-cfdd-4630-8281-738bbaed3b9c
# ╠═58428158-84ac-44e4-9b38-b991728cd98a
# ╠═9979ebaf-5cd9-4695-b8a5-6b45c78b3fa0
# ╠═c4a7bdf8-315d-4a57-a005-83a66419a507
# ╠═4a0314a6-7dc0-4ee9-842b-3f9bd4d61fb1
# ╠═cc62929e-f9af-11ea-06b9-439ac08dcb52
# ╟─d3d7bd9c-f9af-11ea-1570-75856615eb5d
# ╟─2f8dedfc-fb98-11ea-23d7-2159bdb6a299
# ╟─b7446f34-f9b1-11ea-0f39-a3c17ba740e5
# ╟─4f97b572-f9b0-11ea-0a99-87af0797bf28
# ╟─4e8d327e-f9b0-11ea-3f16-c178d96d07d9
# ╟─d83f8bbc-f9af-11ea-2392-c90e28e96c65
# ╟─0e465160-f937-11ea-0ebb-b7e02d71e8a8
# ╟─141af892-f933-11ea-1e5f-154167642809
# ╟─7eed9dde-f931-11ea-38b0-db6bfcc1b558
# ╟─7e3282e2-f931-11ea-272f-d90779264456
# ╟─7d1439e6-f931-11ea-2dab-41c66a779262
# ╠═7df55e6c-f931-11ea-33b8-fdc3be0b6cfa
# ╟─292e0384-fb57-11ea-0238-0fbe416fc976
# ╠═7dabee08-f931-11ea-0cb2-c7d5afd21551
# ╟─3736a094-fb57-11ea-1d39-e551aae62b1d
# ╠═13c89272-f934-11ea-07fe-91b5d56dedf8
# ╠═7d60f056-f931-11ea-39ae-5fa18a955a77
# ╟─82e0df62-fb54-11ea-3fff-b16c87a7d45b
# ╠═b7601048-fb57-11ea-0754-97dc4e0623a1
# ╟─cc42de82-fb5a-11ea-3614-25ef961729ab
# ╠═d66fe2b2-fb5a-11ea-280f-cfb12b8296ac
# ╠═4ca8e04a-fb75-11ea-08cc-2fdef5b31944
# ╟─6f613cd2-fb5b-11ea-1669-cbd355677649
# ╠═91e87974-fb78-11ea-3ce4-5f64e506b9d2
# ╠═9f98e00e-fb78-11ea-0f6c-01206e7221d6
# ╟─d7d8cd0c-fb6a-11ea-12bf-2d1448b38162
# ╠═7be98e04-fb6b-11ea-111d-51c48f39a4e9
# ╠═052f822c-fb7b-11ea-382f-af4d6c2b4fdb
# ╠═067f33fc-fb7b-11ea-352e-956c8727c79f
# ╟─7b10f074-fb7c-11ea-20f0-034ddff41bc3
# ╟─24ae5da0-fb7e-11ea-3480-8bb7b649abd5
# ╟─47836744-fb7e-11ea-2305-3fa5819dc154
# ╠═df4fc31c-fb81-11ea-37b3-db282b36f5ef
# ╠═c83b1770-fb82-11ea-20a6-3d3a09606c62
# ╟─52970ac4-fb82-11ea-3040-8bd0590348d2
# ╟─6b4d6584-f3be-11ea-131d-e5bdefcc791b
# ╟─54b1e236-fb53-11ea-3769-b382ef8b25d6
# ╟─b7803a28-fb96-11ea-3e30-d98eb322d19a
# ╟─ddef9c94-fb96-11ea-1f17-f173a4ff4d89
# ╟─ffc17f40-f380-11ea-30ee-0fe8563c0eb1
# ╟─ffc40ab2-f380-11ea-2136-63542ff0f386
# ╟─ffceaed6-f380-11ea-3c63-8132d270b83f
# ╟─ffde44ae-f380-11ea-29fb-2dfcc9cda8b4
# ╟─ffe326e0-f380-11ea-3619-61dd0592d409
# ╟─fff5aedc-f380-11ea-2a08-99c230f8fa32
# ╟─00026442-f381-11ea-2b41-bde1fff66011
# ╟─20c0bfc0-a6ce-4290-95e1-d01264114cb1
# ╟─00115b6e-f381-11ea-0bc6-61ca119cb628
