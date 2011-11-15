#
#  ProcessHeader.rb
#  Magical Record
#
#  Created by Saul Mora on 11/14/11.
#  Copyright 2011 Magical Panda Software LLC. All rights reserved.
#


def processHeader(headerFile)
    unless headerFile.end_with? ".h"
        puts "#{headerFile} not a header"
        return
    end
        
    puts "Reading #{headerFile}"
    
    method_match_expression = /^(?<Start>[\+|\-]\s*\([a-zA-Z\s\*]*\)\s*)(?<MethodName>\w+)(?<End>\:?.*)/
    category_match_expression = /^\s*(?<Interface>@[[:alnum:]]+)\s*(?<ObjectName>[[:alnum:]]+)\s*(\((?<Category>\w+)\))?/
    
    lines = File.readlines(headerFile)
    non_prefixed_methods = []
    processed_methods_count = 0
    
    lines.each { |line|
        
        processed_line = nil
        if line.start_with?("@interface")
            matches = category_match_expression.match(line)
            processed_line = "#{matches[:Interface]} #{matches[:ObjectName]} (#{matches[:Category]}ShortHand)"
        end
        
        if processed_line == nil
            matches = method_match_expression.match(line)

            if matches
                if matches[:MethodName].start_with?("MR_")
                    ++processed_methods_count
                    methodName = matches[:MethodName].sub("MR_", "")
                    processed_line = "#{matches[:Start]}#{methodName}#{matches[:End]}"

                else
                    non_prefixed_methods = nil
                    return
                end
            end
        end
        
        if processed_line == nil
            if line.start_with?("@end")
                processed_line = "@end"
            end
        end
        
        unless processed_line == nil
            #            puts "#{line} ----->  #{processed_line}"
            non_prefixed_methods << processed_line
        end
    }
    
    non_prefixed_methods #unless processed_methods_count == 0
end

def processDirectory(path)

    headers = File.join(path, "**", "*+*.h")
    Dir.glob(headers).each { |file|
#        puts "Processing #{file}"
        
        processDirectory(file) if File.directory?(file)
        if file.end_with?(".h")
            processedInterface = processHeader(file)
            
            puts processedInterface
        end
    }

end

if ARGV[0]
    path = "#{Dir.pwd}/#{ARGV[0]}"
    
    if path.end_with?(".h")
        processedInterface = processHeader(path)
        
        puts processedInterface

    else
        processDirectory(path)
    end

else
    processDirectory(ARGV[0] || Dir.getwd())
end
