
@testset "sizing" begin
    for dims in [(0, 0), (1, 1), (2, 1), (1, 2), (2, 2), (3, 6), (6, 3), (9, 4), (4, 9), (5, 0), (0, 5), (5, 1), (1, 5), (10, 0), (0, 10), (6, 8), (8, 6), (10, 10), (10, 15), (15, 10), (2000, 200), (200, 2000), (2000, 2000)]
        seed!(RNG, 1337)
        p = @inferred heatmap(randn(RNG, dims))
        @test p isa Plot
        test_ref("references/heatmap/default_$(dims[1])x$(dims[2]).txt", @show_col(p, :displaysize=>TERM_SIZE))
    end
end

@testset "axis scaling" begin
    x = repeat(collect(0:10), outer=(1, 11))
    p = @inferred heatmap(x, xscale=0.1)
    test_ref("references/heatmap/scaling_$(size(x, 1))x$(size(x, 2))_xscale_0.1.txt", @show_col(p, :displaysize=>TERM_SIZE))
    p = @inferred heatmap(x, xscale=0.1, xoffset=-0.5)
    test_ref("references/heatmap/scaling_$(size(x, 1))x$(size(x, 2))_xscale_0.1_xoffset-0.5.txt", @show_col(p, :displaysize=>TERM_SIZE))
    p = @inferred heatmap(x, yscale=0.1)
    test_ref("references/heatmap/scaling_$(size(x, 1))x$(size(x, 2))_yscale_0.1.txt", @show_col(p, :displaysize=>TERM_SIZE))
    p = @inferred heatmap(x, yscale=0.1, yoffset=-0.5)
    test_ref("references/heatmap/scaling_$(size(x, 1))x$(size(x, 2))_yscale_0.1_yoffset-0.5.txt", @show_col(p, :displaysize=>TERM_SIZE))
    p = @inferred heatmap(x, xscale=0.1, xoffset=-0.5, yscale=10, yoffset=-50)
    test_ref("references/heatmap/scaling_$(size(x, 1))x$(size(x, 2))_xscale_0.1_xoffset-0.5_yscale_10_yoffset_-50.txt", @show_col(p, :displaysize=>TERM_SIZE))
end

@testset "integer values" begin
    x = repeat(collect(1:20), outer=(1, 20))
    p = @inferred heatmap(x)
    test_ref("references/heatmap/integers_$(size(x, 1))x$(size(x, 2)).txt", @show_col(p, :displaysize=>TERM_SIZE))
end

@testset "color maps" begin
    x = collect(0:30) * collect(0:30)'
    for cmap in keys(UnicodePlots.COLOR_MAP_DATA)
        p = @inferred heatmap(x, colormap=cmap)
        test_ref("references/heatmap/colormap_$(size(x, 1))x$(size(x, 2))_$cmap.txt", @show_col(p, :displaysize=>TERM_SIZE))
    end
    p = @inferred heatmap(x, colormap=reverse(UnicodePlots.COLOR_MAP_DATA[:viridis]))
    test_ref("references/heatmap/colormap_$(size(x, 1))x$(size(x, 2))_reverse_viridis.txt", @show_col(p, :displaysize=>TERM_SIZE))
end

@testset "axis limits" begin
    x = collect(0:30) * collect(0:30)'
    p = @inferred heatmap(x, ylim=[10, 20])
    test_ref("references/heatmap/limits_$(size(x, 1))x$(size(x, 2))_ylim_10_20.txt", @show_col(p, :displaysize=>TERM_SIZE))
    p = @inferred heatmap(x, ylim=[50, 50])
    test_ref("references/heatmap/limits_$(size(x, 1))x$(size(x, 2))_ylim_50_50.txt", @show_col(p, :displaysize=>TERM_SIZE))
    p = @inferred heatmap(x, xlim=[10, 20])
    test_ref("references/heatmap/limits_$(size(x, 1))x$(size(x, 2))_xlim_10_20.txt", @show_col(p, :displaysize=>TERM_SIZE))
    p = @inferred heatmap(x, xlim=[50, 50])
    test_ref("references/heatmap/limits_$(size(x, 1))x$(size(x, 2))_xlim_50_50.txt", @show_col(p, :displaysize=>TERM_SIZE))
    p = @inferred heatmap(x, xlim=[10, 20], ylim=[10, 20])
    test_ref("references/heatmap/limits_$(size(x, 1))x$(size(x, 2))_xlim_10_20_ylim_10_20.txt", @show_col(p, :displaysize=>TERM_SIZE))
    p = @inferred heatmap(x, xlim=[0, 0.1], xscale=0.01)
    test_ref("references/heatmap/limits_$(size(x, 1))x$(size(x, 2))_xscale_0.01_xlim_0_0.1.txt", @show_col(p, :displaysize=>TERM_SIZE))
    p = @inferred heatmap(x, ylim=[0, 0.1], yscale=0.01)
    test_ref("references/heatmap/limits_$(size(x, 1))x$(size(x, 2))_yscale_0.01_ylim_0_0.1.txt", @show_col(p, :displaysize=>TERM_SIZE))
    p = @inferred heatmap(x, xlim=[0, 0.1], xscale=0.01, ylim=[0.1, 0.2], yscale=0.01)
    test_ref("references/heatmap/limits_$(size(x, 1))x$(size(x, 2))_xscale_0.01_xlim_0_0.1_yscale_0.01_ylim_0.1_0.2.txt", @show_col(p, :displaysize=>TERM_SIZE))
    p = @inferred heatmap(x, ylim=[1, 50])
    test_ref("references/heatmap/limits_$(size(x, 1))x$(size(x, 2))_ylim_1_50.txt", @show_col(p, :displaysize=>TERM_SIZE))
    p = @inferred heatmap(x, xlim=[1, 50])
    test_ref("references/heatmap/limits_$(size(x, 1))x$(size(x, 2))_xlim_1_50.txt", @show_col(p, :displaysize=>TERM_SIZE))
    p = @inferred heatmap(x, xlim=[1, 50], ylim=[1, 50])
    test_ref("references/heatmap/limits_$(size(x, 1))x$(size(x, 2))_xlim_1_50_ylim_1_50.txt", @show_col(p, :displaysize=>TERM_SIZE))
end

@testset "all zero values" begin
    x = zeros(20, 20)
    p = @inferred heatmap(x)
    test_ref("references/heatmap/zeros_$(size(x, 1))x$(size(x, 2)).txt", @show_col(p, :displaysize=>TERM_SIZE))
end

@testset "parameters" begin
    seed!(RNG, 1337)
    p = @inferred heatmap(randn(RNG, 200, 200), colorbar=false)
    test_ref("references/heatmap/parameters_200x200_no_colorbar.txt", @show_col(p, :displaysize=>TERM_SIZE))
    seed!(RNG, 1337)
    p = @inferred heatmap(randn(RNG, 200, 200), labels=false)
    test_ref("references/heatmap/parameters_200x200_no_labels.txt", @show_col(p, :displaysize=>TERM_SIZE))
    seed!(RNG, 1337)
    p = heatmap(randn(RNG, 200, 200), title="Custom Title", zlabel="Custom Label", colorbar_border=:ascii, colormap=:inferno)
    test_ref("references/heatmap/parameters_200x200_zlabel_ascii_border.txt", @show_col(p, :displaysize=>TERM_SIZE))
    seed!(RNG, 1337)
    p = @inferred heatmap(randn(RNG, 10, 10), xscale=0.1, colormap=:inferno)
    test_ref("references/heatmap/parameters_10x10_xscale_inferno.txt", @show_col(p, :displaysize=>TERM_SIZE))
    seed!(RNG, 1337)
    p = @inferred heatmap(randn(RNG, 10, 11), xscale=0.1, colormap=:inferno)
    test_ref("references/heatmap/parameters_10x11_xscale_inferno.txt", @show_col(p, :displaysize=>TERM_SIZE))
    seed!(RNG, 1337)
    p = @inferred heatmap(randn(RNG, 10, 10), yscale=1, colormap=:inferno)
    test_ref("references/heatmap/parameters_10x10_yscale_inferno.txt", @show_col(p, :displaysize=>TERM_SIZE))
end
