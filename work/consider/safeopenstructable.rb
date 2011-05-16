# Same as +OpenStructable+ but if attribute was not set before then
# reading it will fail.
#
# Example:
#
#   class X; is OpenStructable
#   end
#   x = X.new
#   x.a = 10
#   x.a      => 10
#   x.b      => "Method missing" error.
#
module SafeOpenStructable
  
  def method_missing(method_id, *args, &block)
    if block then return super(method_id, *args, &block); end
    var = method_id.to_s
    @safeopenstructable_table ||= {}
    table = @safeopenstructable_table
    if var[-1].chr == "=" and args.size == 1 then return table[var.chop] = args[0]; end
    if not var[-1].chr == "=" and args.empty? and table.has_key?(var) then return table[var]; end
    super(method_id, *args, &block)
  end
  
end

