#lang scribble/manual

@(require (for-label slideshow)
          "common.rkt")

@declare-exporting[plot]

@title[#:tag "plot2d"]{2D Plot Procedures}

@defproc[(plot [renderer-tree (treeof renderer2d?)]
               [#:x-min x-min (or/c real? #f) #f] [#:x-max x-max (or/c real? #f) #f]
               [#:y-min y-min (or/c real? #f) #f] [#:y-max y-max (or/c real? #f) #f]
               [#:width width (integer>=/c 1) (plot-width)]
               [#:height height (integer>=/c 1) (plot-height)]
               [#:title title (or/c string? #f) (plot-title)]
               [#:x-label x-label (or/c string? #f) (plot-x-label)]
               [#:y-label y-label (or/c string? #f) (plot-y-label)]
               [#:legend-anchor legend-anchor anchor/c (plot-legend-anchor)]
               [#:out-file out-file (or/c path-string? output-port? #f) #f]
               [#:out-kind out-kind (one-of/c 'auto 'png 'jpeg 'xmb 'xpm 'bmp 'ps 'pdf 'svg) 'auto]
               ) (or/c (is-a?/c snip%) void?)]{
Plots a 2D renderer or list of renderers (or more generally, a tree of renderers), as returned by @(racket points), @(racket function), @(racket contours), @(racket discrete-histogram), and others.

By default, @(racket plot) produces a Racket value that is displayed as an image and can be manipulated like any other value.
For example, they may be put in lists:

@interaction[#:eval plot-eval
                    (parameterize ([plot-width    150]
                                   [plot-height   150]
                                   [plot-x-label  #f]
                                   [plot-y-label  #f])
                      (list (plot (function sin (- pi) pi))
                            (plot (function sqr -2 2))))]

When the parameter @(racket plot-new-window?) is @(racket #t), @(racket plot) opens a new window to display the plot and returns @(racket (void)).

When @(racket #:out-file) is given, @(racket plot) writes the plot to a file using @(racket plot-file) as well as returning a @(racket snip%) or opening a new window.

When given, the @(racket x-min), @(racket x-max), @(racket y-min) and @(racket y-max) arguments determine the bounds of the plot, but not the bounds of the renderers. For example,

@interaction[#:eval plot-eval
(plot (function (λ (x) (sin (* 4 x))) -1 1)
      #:x-min -1.5 #:x-max 1.5 #:y-min -1.5 #:y-max 1.5)]

Here, the renderer draws in [-1,1] × [-1,1], but the plot area is [-1.5,1.5] × [-1.5,1.5].

The @(racket plot) function easily generates plots for slideshows. For example,

@racketmod[slideshow
(require plot)

(plot-font-size (current-font-size))
(plot-width (current-para-width))
(plot-height 600)

(slide
 #:title "A 2D Parabola"
 (bitmap (plot (function sqr -1 1 #:label "y = x^2"))))]

creates a slide containing a 2D plot of a parabola.

@bold{Deprecated keywords.} The @(racket #:fgcolor) and @(racket #:bgcolor) keyword arguments are currently supported for backward compatibility, but may not be in the future.
Please set the @(racket plot-foreground) and @(racket plot-background) parameters instead of using these keyword arguments.
The @(racket #:lncolor) keyword argument is also accepted for backward compatibility but deprecated. It does nothing.
}

@deftogether[
(@defproc[(plot-file [renderer-tree (treeof renderer2d?)]
                     [output (or/c path-string? output-port?)]
                     [kind (one-of/c 'auto 'png 'jpeg 'xmb 'xpm 'bmp 'ps 'pdf 'svg) 'auto]
                     [#:<plot-keyword> <plot-keyword> <plot-keyword-contract>] ...) void?]
 @defproc[(plot-bitmap [renderer-tree (treeof renderer2d?)] ...) (is-a?/c bitmap%)]
 @defproc[(plot-snip [renderer-tree (treeof renderer2d?)] ...) (is-a?/c snip%)]
 @defproc[(plot-frame [renderer-tree (treeof renderer2d?)] ...) (is-a?/c frame%)])]{
Plot to different backends. Each of these procedures has the same keyword arguments as @(racket plot).

Use @(racket plot-file) to save a plot to a file.
When creating a JPEG file, the parameter @(racket plot-jpeg-quality) determines its quality.
When creating a PostScript or PDF file, the parameters @(racket plot-ps-interactive?) and @(racket plot-pdf-interactive?) determine whether the user is given a dialog for setting printing parameters.
(See @(racket post-script-dc%) and @(racket pdf-dc%).)
When @(racket kind) is @(racket 'auto), @(racket plot-file) tries to determine the kind of file to write from the file name extension.

Use @(racket plot-bitmap) to create a bitmap.

Use @(racket plot-frame) to create a frame regardless of the value of @(racket plot-new-window?). The frame is initially hidden.

Use @(racket plot-snip) to create a snip regardless of the value of @(racket plot-new-window?).
}

@doc-apply[plot/dc]{
Plots to an arbitrary device context.
The width and height of the plot are the device context's width and height.
Every @secref{plot2d} procedure is defined in terms of @(racket plot/dc).

Use this if you need to continually update a plot on a @(racket canvas%), or to create other @(racket plot)-like functions with different backends.
}

@section{Deprecated 2D Functions}

The following functions exist for backward compatibility, but may be removed in the future.
Set @(racket (plot-deprecation-warnings? #t)) to be alerted the first time one is used.

@defproc[(mix [plot-data (any/c . -> . void?)] ...)
         (any/c . -> . void?)]{
See @(secref "compat").
}

@doc-apply[line]{
See @(secref "compat").
}

@doc-apply[contour]{
See @(secref "compat").
}

@doc-apply[shade]{
See @(secref "compat").
}
