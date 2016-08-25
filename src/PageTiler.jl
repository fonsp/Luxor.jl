"""
A PageTiler is an iterator that returns the `x`/`y` coordinates of a set of
imaginary tiles that divide up a rectangular space into rows and columns.

    pagetiles = PageTiler(areawidth, areaheight, nrows, ncols, margin=20)

where width, height is the dimensions of the area to be tiled, nrows/ncols
is the number of rows and columns required, and margin is applied to area
before the tile sizes are calculated.

Access the calculated tile width and height like this:

    pagetiles = PageTiler(1000, 800, 4, 5, margin=20)
    for (xpos, ypos, n) in pagetiles
      ellipse(xpos, ypos, pagetiles.tilewidth, pagetiles.tileheight, :fill)
    end
"""
type PageTiler
  width
  height
  tilewidth
  tileheight
  nrows
  ncols
  margin
  function PageTiler(pagewidth, pageheight, nrows::Int, ncols::Int; margin=10)
      tilewidth  = (pagewidth  - 2 * margin)/ncols
      tileheight = (pageheight - 2 * margin)/nrows
      new(pagewidth, pageheight, tilewidth, tileheight, nrows, ncols, margin)
  end
end

function Base.start(pt::PageTiler)
# return the initial state
  x = -(pt.width/2)  + pt.margin + (pt.tilewidth/2)
  y = -(pt.height/2) + pt.margin + (pt.tileheight/2)
  return (x, y, 1)
end

function Base.next(pt::PageTiler, state)
  # Returns the item and the next state
  x = state[1]
  y = state[2]
  tilenumber = state[3]
  x1 = x + pt.tilewidth
  y1 = y
  if x1 > (pt.width/2) - pt.margin
    y1 += pt.tileheight
    x1 = -(pt.width/2) + pt.margin + (pt.tilewidth/2)
  end
  return ((x, y, tilenumber), (x1, y1, tilenumber + 1))
end

function Base.done(pt::PageTiler, state)
  # Tests if there are any items remaining
  state[3] > (pt.nrows * pt.ncols)
end