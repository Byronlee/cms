class AdsCell < Cell::Rails
  helper ApplicationHelper

  def position_1
    render
  end

  def position_2(args)
    @head_line = args[:head_line] || {}
    render
  end

  def position_3
    render
  end

  def position_7
    render
  end

  def position_8
    render
  end

  def position_9
    render
  end

  def position_10
    render
  end

  def sponsors
    render
  end
end
