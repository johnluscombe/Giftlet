module GiftsHelper
  def can_edit_gift?
    current_user?(@user) or current_user.site_admin?
  end

  def editing(gift)
    can_edit_gift? and params[:render_edit].to_i == gift.id
  end

  def purchased_by(gift)
    if gift.purchaser_id == current_user.id
      purchased_by_you(gift)
    elsif gift.purchaser_id
      purchased_by_other(gift)
    else
      purchased_by_nil
    end
  end

  def mark_as_purchased(gift)
    link_to(gift_mark_as_purchased_path(gift),
            method: :patch, class: 'btn btn-sm btn-secondary') do

      content_tag(:i, nil, class: 'fa fa-check')
    end
  end

  def gift_name(gift)
    if gift.url.blank?
      content = gift.name
    else
      content = link_to gift.name, gift.full_url, target: '_blank'
    end

    content_tag(:span, content)
  end

  def gift_price(gift)
    if !gift.price.blank? and gift.price != 0.0
      content_tag(:span, number_to_currency(gift.price), class: 'gift-price')
    end
  end

  def gift_description(gift)
    if gift.description.nil? or gift.description.delete(' ') == ''
      content_tag(:i, 'No description provided.', class: 'text-muted')
    else
      gift.description
    end
  end

  def gift_edit(gift)
    link_to user_gifts_path(@user, render_edit: gift.id), class: 'btn btn-sm btn-secondary' do
      content_tag(:i, nil, class: 'fa fa-pencil', 'aria-hidden': 'true')
    end
  end

  def gift_delete(gift)
    confirm_text = 'Are you sure you want to delete this gift?'

    link_to gift_path(gift), method: :delete, class: 'btn btn-sm btn-secondary', data: { confirm: confirm_text } do
      content_tag(:i, nil, class: 'fa fa-trash', 'aria-hidden': 'true')
    end
  end

  def add_gift_button
    link_to user_gifts_path(@user, render_new: true), class: 'btn btn-outline-success btn-block' do
      content_tag(:i, nil, class: 'fa fa-plus') + 'ADD GIFT'
    end
  end

  def name_field(form)
    form.text_field(:name,
                    class: 'form-control form-control-sm gift-name-field',
                    placeholder: 'Name',
                    required: true)
  end

  def url_field(form)
    form.text_field(:url,
                    class: 'form-control form-control-sm gift-url-field',
                    placeholder: 'URL (optional)')
  end

  def description_field(form)
    form.text_area(:description,
                   class: 'form-control form-control-sm',
                   placeholder: 'Description (optional)')
  end

  def price_field(form)
    form.text_field(:price_as_dollars,
                    class: 'form-control form-control-sm gift-price-field',
                    placeholder: 'Price')
  end

  def gift_submit_button
    button_tag class: 'btn btn-primary btn-sm gift-save' do
      content_tag(:i, nil, class: 'fa fa-save')
    end
  end

  def gift_cancel_button
    link_to user_gifts_path(@user), class: 'btn btn-secondary btn-sm gift-cancel' do
      content_tag(:i, nil, class: 'fa fa-times')
    end
  end

  private

  def purchased_by_you(gift)
    link_to gift_mark_as_unpurchased_path(gift),
            method: :patch, class: 'btn btn-sm btn-success' do

      content_tag(:i, nil, class: 'fa fa-check')
    end
  end

  def purchased_by_other(gift)
    text = "#{ gift.purchaser.first_name } #{ gift.purchaser.last_name }"
    icon = content_tag(:i, nil, class: 'fa fa-check')

    if current_user.site_admin?
      link_to gift_mark_as_unpurchased_path(gift),
              method: :patch, class: 'btn btn-sm btn-outline-success' do
        icon + text
      end
    else
      content_tag(:span, icon + text, class: 'text-success text-nowrap')
    end
  end

  def purchased_by_nil
    content_tag(:i, 'Purchased', class: 'fa fa-check text-success')
  end
end
