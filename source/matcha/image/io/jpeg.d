module matcha.image.io.jpeg;

import matcha.math.matrix;

import libjpeg.jpeglib;

import std.file;
import std.c.string;

unittest { import std.stdio; writeln(__MODULE__, " : test start"); }

Matrix!(ubyte) readJPEG(in char[] path)
{
	auto buf = cast(ubyte[])read(path);

	jpeg_decompress_struct jds;
	jpeg_error_mgr jem;
	jds.err = jpeg_std_error(&jem);

	jpeg_create_decompress(&jds);
	jpeg_mem_src(&jds, cast(ubyte*)(cast(void*)buf), cast(uint)buf.length);
	jpeg_read_header(&jds, true);
	jpeg_start_decompress(&jds);

	const auto row_stride = jds.output_width * jds.output_components;
	JSAMPARRAY scan_buffer = jds.mem.alloc_sarray(
		cast(jpeg_common_struct*)(&jds), JPOOL_IMAGE, row_stride, 1);

	auto r = new Matrix!(ubyte)(jds.output_height, jds.output_width, 3);

	while(jds.output_scanline < jds.output_height)
	{
		auto i = jds.output_scanline;
		jpeg_read_scanlines(&jds, scan_buffer, 1);
		memcpy(&r[i*row_stride], scan_buffer[0], row_stride);
	}

	jpeg_finish_decompress(&jds);
	jpeg_destroy_decompress(&jds);

	return r;
}

unittest
{
	import std.stdio;
	import std.file;
	import std.path;
	import std.string;

	auto m = readJPEG(
		format("%s/%s", dirName(thisExePath()), "test_0001.jpg") );

	for(auto r = 0; r < m.rows; ++r)
	{
		for(auto c = 0; c < m.cols; ++c)
		{
			const ubyte v = 128;
			assert( m[r,c,0] == v && m[r,c,1] == v && m[r,c,2] == v);
		}
	}
}

unittest { import std.stdio; writeln(__MODULE__, " : test clear"); }

