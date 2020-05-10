/// TF C-API for various platforms.
module tfd.c_api;

version (Windows)
{
  public import tfd.c_api.windows;
}
else version (linux)
{
  public import tfd.c_api.linux;
}
else
{
  static assert(false, "only Linux and Windows are supported.");
}
