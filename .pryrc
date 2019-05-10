Pry.config.prompt = [
  lambda { |obj,lvl,pry| sprintf "pry [%s] (%s) (%s)$ ", RUBY_VERSION, File.basename(Dir.pwd), obj, lvl },
  lambda { |obj,lvl,pry| sprintf "pry [%s] (%s) (%s)* ", RUBY_VERSION, File.basename(Dir.pwd), obj, lvl }
]  
