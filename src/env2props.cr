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
      .downcase       # all downcase
      .gsub("_", ".") # all underscores to dots

    # given https://docs.oracle.com/javase/8/docs/api/java/util/Properties.html#load-java.io.InputStream-
    encoding = "ISO8859-1"
    str = String.new(bytes: v.encode(encoding), encoding: encoding)

    str = str.dump

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
