class Post
  attr_reader :title, :url

  def initialize(title, url, points, item_id, comments)
    @title = title
    @url = url
    @points = points
    @item_id = item_id
    @comments = comments
  end

  def comments
    @comments
  end

  def add_comment(comment)
    @comments << comment
  end

  def num_of_comments
    @comments.length
  end

  def user_with_most_comments
    user_post_count = Hash.new(0)
    @comments.each do |comment| 
      user_post_count[comment.user] += 1
    end
    
    user, comments = user_post_count.max_by { |k,v| v}
    "#{user}, with #{comments} comments"
  end

  def longest_comment
    max_comment = @comments.max do |a, b| 
      a.message.length <=> b.message.length
    end
    "#{max_comment.message.length} characters, by #{max_comment.user}."
  end

  def first_five_comments
    number_of_comments = @comments.length >= 5 ? 4 : @comments.length-1
    comments = ''
    for i in 0..number_of_comments
      comments << "By #{@comments[i].user}".colorize(:color => :light_cyan, :background => :black)
      comments << '    '.colorize(:color => :light_cyan, :background => :black)
      comments << "#{@comments[i].date}".colorize(:color => :light_yellow, :background => :black)
      comments << "\n"
      comments << "#{@comments[i].message}".colorize(:cyan)
      comments << "\n"
    end

    comments
  end

  def sort_by_time(arr)
    time_values = {
      'second' => 1,
      'seconds' => 1,
      'minute' => 2,
      'minutes' => 2,
      'hour' => 3,
      'hours' => 3,
      'day' => 4,
      'days' => 4,
      'year' => 5,
      'years' => 5
    }

    arr.sort do |a, b|
      a_number, a_unit = a.date.split(' ')
      b_number, b_unit = b.date.split(' ') 

      a_unit = time_values[a_unit]
      b_unit = time_values[b_unit]
      
      [a_unit, a_number.to_i] <=> [b_unit, b_number.to_i]
    end
  end
  
  def most_recent_comments

    arr = sort_by_time(@comments)

    number_of_comments = arr.length >= 5 ? 4 : arr.length-1
    comments = ''
    for i in 0..number_of_comments
      comments << "By #{arr[i].user}".colorize(:color => :light_cyan, :background => :black)
      comments << '    '.colorize(:color => :light_cyan, :background => :black)
      comments << "#{arr[i].date}".colorize(:color => :light_yellow, :background => :black)
      comments << "\n"
      comments << "#{arr[i].message}".colorize(:cyan)
      comments << "\n"
    end

    comments
  end
end