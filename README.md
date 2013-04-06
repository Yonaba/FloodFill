FloodFill
=========

A command-line program to compare different floodfill algorithms on a set of grid maps, and benchmark them as well.
I have been working on this as a side project to outline what would probably be the best way (mostly in terms of speed)
to flood an entire grid map. Something I wanted [to include](https://github.com/Yonaba/Jumper/issues/3) as a optional feature to my 
pathfinding library [Jumper](https://github.com/Yonaba/Jumper).

After some commits, I came up with some interesting results, then I tried to clean the code and git it.

##Download
You can retrieve the contents of this repository locally on your computer with the following bash command:
```bash
git clone git://github.com/Yonaba/FloodFill
```

You can also download the repository as a [.zip](https://github.com/Yonaba/FloodFill/zipball/master) or [.tar.gz](https://github.com/Yonaba/FloodFill/tarball/master) file

##Requirements:
The following program should be run from command line.
It uses __LuaFileSystem__, so make sure to have this dependency installed and working properly on your computer.
Find relevant instructions [here](http://keplerproject.github.com/luafilesystem/).

##Usage

````
lua main.lua -m = <mapName> -n = <i> -i = <...> -u = <...> -o = <logFile>
```

* `-m = mapName` : where <tt>mapName</tt> is the exact name of a [mapFile](http://github.com/Yonaba/FloodFill/blob/master/maps/). The extension '.map' can be left. Defaults to string `'all'`, meaning the full set of maps.
* `-n = i` : where <tt>i</tt> is the number of repetitions of floofill with for the same floodfill with the same grid map. The time returned will be the mean time plus standard deviation. Defaults to `1`.
* `-i = ...` : specifies the floddfill algorithms to be ignored. To pass a set, separate their names with a dot (.) character.
* `-u = ...` : same as the previous, but `-u` flag specifies the algorithms to be used only.
* `-o = logFile` : where <tt>logFile</tt> is the name of a logging file which will be exported near `main.lua`.

A simple example:
````
-- Runs flood4 twenty times on ht_store.map
lua main.lua -n=20 -m=ht_store -u=flood4
````

Another example:
````
-- Runs all algorithms but flood4 and flood8, each one 15 times on lt_shop.map
lua main.lua -n=15 -m=lt_shop -i=flood4.flood8
```

The full list of algorithms that can be passed to `-u` and `-i` flags are:

* __flood4__ (the recursive 4-way variant, see [flood4.lua](http://github.com/Yonaba/FloodFill/blob/master/floodfill/flood4.lua))
* __flood8__ (the recursive 8-way variant, see [flood8.lua](http://github.com/Yonaba/FloodFill/blob/master/floodfill/flood8.lua))
* __flood4Stack__ (the stack based 4-way variant, see [flood4stack.lua](http://github.com/Yonaba/FloodFill/blob/master/floodfill/flood4stack.lua))
* __flood4Queue__ (the queue based 4-way variant, see [flood4stack.lua](http://github.com/Yonaba/FloodFill/blob/master/floodfill/flood4stack.lua))
* __floodScanline__ (scanline floodfill, see [floodscanline.lua](http://github.com/Yonaba/FloodFill/blob/master/floodfill/floodscanline.lua))
* __floodScanlineStack__ (stack-based scanline floodfill, see [floodstackscanline.lua](http://github.com/Yonaba/FloodFill/blob/master/floodfill/floodstackscanline.lua))
* __floodScanlineQueue__ (queue-based scanline floodfill, see [floodstackscanline.lua](http://github.com/Yonaba/FloodFill/blob/master/floodfill/floodstackscanline.lua))
* __floodWestEastStack__ (stack-based west and east looping floodfill, see [floodwesteast.lua](http://github.com/Yonaba/FloodFill/blob/master/floodfill/floodwesteast.lua))
* __floodWestEastQueue__ (queue-based west and east looping floodfill, see [floodwesteast.lua](http://github.com/Yonaba/FloodFill/blob/master/floodfill/floodwesteast.lua))

##Maps
Maps were taken from the [2012 Grid-Based Path Planning Competition](http://movingai.com/GPPC/).<br/>
Map files format and description are given [here](http://www.movingai.com/benchmarks/formats.html).<br/>
The mapfile parser source can be found here: [parser.lua](http://github.com/Yonaba/FloodFill/blob/master/utils/parser.lua).

##License##
This work is under [MIT-LICENSE](http://www.opensource.org/licenses/mit-license.php)<br/>
Copyright (c) 2013 Roland Yonaba

    Permission is hereby granted, free of charge, to any person obtaining a
    copy of this software and associated documentation files (the
    "Software"), to deal in the Software without restriction, including
    without limitation the rights to use, copy, modify, merge, publish,
    distribute, sublicense, and/or sell copies of the Software, and to
    permit persons to whom the Software is furnished to do so, subject to
    the following conditions:

    The above copyright notice and this permission notice shall be included
    in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
    OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
    MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
    IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
    CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
    TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
    SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.