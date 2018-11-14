"""
`boxplot(data; nargs...)` → `Plot`

Description
============

Draws a box-and-whisker plot.
The first argument specifies the data to plot. This is a vector of vectors, with each
inner vector representing a data series. We use a vector of vectors over a matrix
to allow series of different lengths.
Optionally, a list of text may be provided, with length equal to the number of series.
Alternatively, one can specify a boxplot using a dictionary.
In that case, the values, which have to be numeric, will be used as the data series,
and the keys, which have to be strings, will be used as the labels.


Usage
======

    boxplot([text], data; border = :corners, title = "", xlabel = "", ylabel = "", labels = true, margin = 3, padding = 1, color = :green, width = 40, xlim)

    boxplot(dictionary; nargs...)

Arguments
==========

- **`text`** : Optional. The labels/captions of the boxes.

- **`data`** : The data the box plot is based on. A vector of
  vectors, with each inner vector representing a data series.
  Choose a vector of vectors over a matrix to allow series of
  different lengths.

- **`dictionary`** : A dictonary in which the keys will be used
  as `text` and the values will be utilized as `data`.

$DOC_PLOT_PARAMS

Returns
========

A plot object of type `Plot{BoxplotGraphics}`

Author(s)
==========

- Matthew Lake (Github: https://github.com/mgtlake)

Examples
=========

    julia> boxplot([1, 2, 3, 7], title = "Test")

                       Test
     ┌────────────────────────────────────────┐
     │    │   ┌──┬───────┐              │     │
     │    ├───┤  │       ├──────────────┤     │
     │    │   └──┴───────┘              │     │
     └────────────────────────────────────────┘
     0                  4.0                   8

See also
=========

`Plot`, `histogram`, `BoxplotGraphics`
"""
function boxplot(
        text::AbstractVector{<:AbstractString},
        data::AbstractVector{<:AbstractArray{<:Number}};
        border = :corners,
        color::Symbol = :green,
        width::Int = 40,
        xlim::AbstractVector = [0., 0.],
        kw...)
    length(xlim) == 2 || throw(ArgumentError("xlim must only be vectors of length 2"))
    length(text) == length(data) || throw(DimensionMismatch("Wrong number of text"))
    min_x, max_x = extend_limits(reduce(vcat, data), xlim)
    width = max(width, 10)

    area = BoxplotGraphics(data[1], width, color = color,
                           min_x = min_x, max_x = max_x)
    for i in 2:length(data)
        addseries!(area, data[i])
    end

    new_plot = Plot(area; border = border, kw...)

    mean_x = (min_x + max_x) / 2
    min_x_str = string(roundable(min_x) ? round(Int, Float64(min_x), RoundNearestTiesUp) : min_x)
    mean_x_str = string(roundable(mean_x) ? round(Int, Float64(mean_x), RoundNearestTiesUp) : mean_x)
    max_x_str = string(roundable(max_x) ? round(Int, Float64(max_x), RoundNearestTiesUp) : max_x)
    annotate!(new_plot, :bl, min_x_str, color = :light_black)
    annotate!(new_plot, :b,  mean_x_str, color = :light_black)
    annotate!(new_plot, :br, max_x_str, color = :light_black)

    for (i, name) in enumerate(text)
        # Find end of last 3-line region, then add 2 for centre of current
        length(name) > 0 && annotate!(new_plot, :l, (i-1)*3+2, name)
    end

    new_plot
end

"""
`boxplot!(plot, data; nargs)` → `Plot`

Mutating variant of `boxplot`, in which the first parameter (`plot`) specifies
the existing plot to draw on.

See `boxplot` for more information.
"""
function boxplot!(
        plot::Plot{<:BoxplotGraphics},
        data::AbstractVector{<:Number};
        name = " ",
        xlim::AbstractVector = [0., 0.],
        kw...)
    !isempty(data)|| throw(ArgumentError("Can't append empty array to boxplot"))

    min_x, max_x = extend_limits(data, xlim)
    plot.graphics.min_x = min(plot.graphics.min_x, min_x)
    plot.graphics.max_x = min(plot.graphics.max_x, max_x)

    addseries!(plot.graphics, data)

    # Find end of last 3-line region, then add 2 for centre of current
    annotate!(plot, :l, (length(plot.graphics.data)-1)*3+2, name)

    min_x = plot.graphics.min_x
    max_x = plot.graphics.max_x
    mean_x = (min_x + max_x) / 2
    min_x_str = string(roundable(min_x) ? round(Int, Float64(min_x), RoundNearestTiesUp) : min_x)
    mean_x_str = string(roundable(mean_x) ? round(Int, Float64(mean_x), RoundNearestTiesUp) : mean_x)
    max_x_str = string(roundable(max_x) ? round(Int, Float64(max_x), RoundNearestTiesUp) : max_x)
    annotate!(plot, :bl, min_x_str)
    annotate!(plot, :b,  mean_x_str)
    annotate!(plot, :br, max_x_str)

    plot
end

function boxplot(data::AbstractVector{<:AbstractArray{<:Number}}; kw...)
    boxplot(fill("", length(data)), data; kw...)
end

function boxplot(data::AbstractVector{<:Number}; kw...)
    boxplot("", data; kw...)
end

function boxplot(text::AbstractString, data::AbstractVector{<:Number}; kw...)
    boxplot([text], [data]; kw...)
end

function boxplot(dict::Dict; kw...)
    boxplot(collect(keys(dict)), collect(values(dict)); kw...)
end
