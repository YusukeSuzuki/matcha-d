module matcha.math.types.scalar;

import std.traits;

unittest { import std.stdio; writeln(__MODULE__, " : test start"); }

struct Scalar(T,uint C)
{
	T[C] a;
	alias a this;
}

alias Scalar8SC1 = Scalar!(byte,1);
alias Scalar8SC2 = Scalar!(byte,2);
alias Scalar8SC3 = Scalar!(byte,3);
alias Scalar8SC4 = Scalar!(byte,4);
alias Scalar16SC1 = Scalar!(short,1);
alias Scalar16SC2 = Scalar!(short,2);
alias Scalar16SC3 = Scalar!(short,3);
alias Scalar16SC4 = Scalar!(short,4);
alias Scalar32SC1 = Scalar!(int,1);
alias Scalar32SC2 = Scalar!(int,2);
alias Scalar32SC3 = Scalar!(int,3);
alias Scalar32SC4 = Scalar!(int,4);
alias Scalar64SC1 = Scalar!(long,1);
alias Scalar64SC2 = Scalar!(long,2);
alias Scalar64SC3 = Scalar!(long,3);
alias Scalar64SC4 = Scalar!(long,4);

alias Scalar8UC1 = Scalar!(ubyte,1);
alias Scalar8UC2 = Scalar!(ubyte,2);
alias Scalar8UC3 = Scalar!(ubyte,3);
alias Scalar8UC4 = Scalar!(ubyte,4);
alias Scalar16UC1 = Scalar!(ushort,1);
alias Scalar16UC2 = Scalar!(ushort,2);
alias Scalar16UC3 = Scalar!(ushort,3);
alias Scalar16UC4 = Scalar!(ushort,4);
alias Scalar32UC1 = Scalar!(uint,1);
alias Scalar32UC2 = Scalar!(uint,2);
alias Scalar32UC3 = Scalar!(uint,3);
alias Scalar32UC4 = Scalar!(uint,4);
alias Scalar64UC1 = Scalar!(ulong,1);
alias Scalar64UC2 = Scalar!(ulong,2);
alias Scalar64UC3 = Scalar!(ulong,3);
alias Scalar64UC4 = Scalar!(ulong,4);

alias Scalar32FC1 = Scalar!(float,1);
alias Scalar32FC2 = Scalar!(float,2);
alias Scalar32FC3 = Scalar!(float,3);
alias Scalar32FC4 = Scalar!(float,4);
alias Scalar64FC1 = Scalar!(double,1);
alias Scalar64FC2 = Scalar!(double,2);
alias Scalar64FC3 = Scalar!(double,3);
alias Scalar64FC4 = Scalar!(double,4);

auto makeScalar(Args...)(Args args)
{
	Scalar!(CommonType!Args,args.length) r = {[args[]]};
	return r;
}

static void add(ulong i,T,uint C)(
	in Scalar!(T,C) a, in Scalar!(T,C) b, ref Scalar!(T,C) r)
{
	r[i-1] = a[i-1] + b[i-1];
	add!(i-1,T,C)(a,b,r);
}

static void add(ulong i:0,T,uint C)(
	in Scalar!(T,C) a, in Scalar!(T,C) b, ref Scalar!(T,C) r)
{
	return;
}

Scalar!(T,C) add(T,uint C)(in Scalar!(T,C) a, in Scalar!(T,C) b)
{
	Scalar!(T,C) r;
	add!(C,T,C)(a,b,r);
	return r;
}

static void add(ulong i,T,uint C)(
	in Scalar!(T,C) a, in T b, ref Scalar!(T,C) r)
{
	r[i-1] = a[i-1] + b;
	add!(i-1,T,C)(a,b,r);
}

static void add(ulong i:0,T,uint C)(
	in Scalar!(T,C) a, in T b, ref Scalar!(T,C) r)
{
	return;
}

Scalar!(T,C) add(T,uint C)(in Scalar!(T,C) a, in T b)
{
	Scalar!(T,C) r;
	add!(C,T,C)(a,b,r);
	return r;
}

auto testFunc(T,uint i)(T[i] a)
{
	return i;
}

unittest
{
	Scalar32UC3 a = makeScalar(1u,2u,3u);
	Scalar32UC3 b = makeScalar(3u,4u,5u);
	auto c = add(a,b);
	assert(c[0] == 4 && c[1] == 6 && c[2] == 8);
}

unittest { import std.stdio; writeln(__MODULE__, " : test clear"); }
