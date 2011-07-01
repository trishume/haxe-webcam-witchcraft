package ;

class ColorConverter 
{

    public static inline function toRGB(int:Int) : RGB
    {
        return {
            r: ((int >> 8) & 255),
            g: ((int >> 16) & 255),
            b: ((int >> 24) & 255),
						a: (int & 255),
        }
    }
		public static inline function toRGB2(int:Int) : RGB
    {
        return {
            r: ((int >> 16) & 255),
            g: ((int >> 8) & 255),
            b: ((int) & 255),
						a: 0xFF,
        }
    }
		public static function colorDistance(c1 : RGB,c2 : RGB) : Float
		{
		 var dis : Float = 0;
		 dis += Math.pow(c1.r-c2.r,2);
		 dis += Math.pow(c1.g-c2.g,2);
		 dis += Math.pow(c1.b-c2.b,2);

		 dis = Math.sqrt(dis);
		 return dis;   
		}
    
    public static function toInt(rgb:RGB, alpha = 0xFF) : Int
    {
        return (rgb.b << 24) | (rgb.g << 16) | (rgb.r << 8) | rgb.a;
    }
    
}

typedef RGB = {
    var r:Int;
    var g:Int;
    var b:Int;
		var a:Int;
}