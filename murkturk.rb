require 'rturk'

# murkturk is a product by kristina butkute and francesco canessa murks - sorry for the crazy naming and api lol

# code is strongly based on https://github.com/ryantate/rturk

NO = false
YES = true

class Murkturk
  TEST = NO
  # TEST = YES

  AWSAccessKeyId = "AKIAI3GCFP6A7U5VGW4A"
  AWSAccessKey = File.read("aws_access_key.txt").strip

  def initialize
    RTurk.setup AWSAccessKeyId, AWSAccessKey, sandbox: TEST
  end

  # murk the answers
  def murk!
    []
  end

  # doublecheck answers
  def murkmurk

  end

  # turk a question
  def turk
    word = "murk"
    # title = "What is a #{word}?"
    title = "Who will be the next US president?"

    hit = RTurk::Hit.create(title: title) do |hit|
      hit.max_assignments = 1
      hit.description = 'question - testing out the service'
      hit.question("https://15c43218.ngrok.com",
                   :frame_height => 1000)  # pixels for iframe
      hit.reward = 0.03
      hit.qualifications.add :approval_rate, { gt: 70 }
    end

    p hit.url #=>  'https://workersandbox.mturk.com:443/mturk/preview?groupId=Q29J3XZQ1ASZH5YNKZDZ'
    hits = RTurk::Hit.all_reviewable

    puts "#{hits.size} reviewable hits. \n"

    unless hits.empty?
      puts "Reviewing all assignments"

      hits.each do |hit|
        hit.assignments.each do |assignment|
          puts assignment.answers['tags']
          assignment.approve! if assignment.status == 'Submitted'
          puts "approved assignment"
          puts assignment
        end
      end
    end
  end
end

mt = Murkturk.new

puts "Question:"
puts mt.turk

murks = mt.murk!

puts "Answers:"
for murk in murks
  puts murk
end
