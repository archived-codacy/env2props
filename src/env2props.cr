require "option_parser"

prefix = ""

OptionParser.parse! do |parser|
  parser.banner = "Usage: env2prop [arguments]"
  parser.on("-p PREFIX", "--prefix=PREFIX", "Transform only the ENV variables that have the provided prefix") { |p| prefix = p }
  parser.on("-h", "--help", "Show this help") { puts parser }
  parser.invalid_option do |flag|
    STDERR.puts "ERROR: #{flag} is not a valid option."
    STDERR.puts parser
    exit(1)
  end
end

first = true

props = String.build do |props|
  ENV.each do |k, v|
    if !k.starts_with?(prefix)
      next
    end

    key = k
      .lchop(prefix)
      .gsub("_", ".") # all underscores to dots

    # given https://docs.oracle.com/javase/8/docs/api/java/util/Properties.html#load-java.io.InputStream-
    encoding = "ISO8859-1"
    str = String.new(bytes: v.encode(encoding), encoding: encoding)

    # given: https://docs.oracle.com/javase/7/docs/technotes/tools/windows/java.html
    # If value is a string that contains spaces, then you must enclose the string in double quotation marks:
    if str.includes?(' ')
      str = str.dump
    else
      str = str.dump_unquoted
    end

    if (key.size > 1) || (key.size == 1 && key[0].alphanumeric?)
      if first
        first = false
      else
        props << " "
      end

      props << "-D#{key}=#{str}"
    end
  end
end

STDOUT.set_encoding("UTF-8")
STDOUT.print props
