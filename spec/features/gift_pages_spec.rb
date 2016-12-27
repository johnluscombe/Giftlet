require_relative '../rails_helper'
require_relative '../support/login'

describe 'Gift Pages' do
  let(:user) { FactoryGirl.create(:user) }
  let(:second_user) { FactoryGirl.create(:user) }
  let(:third_user) { FactoryGirl.create(:user) }

  subject { page }

  describe 'viewing own gifts' do
    before do
      2.times { FactoryGirl.create(:gift, user: user) }
      2.times { FactoryGirl.create(:gift, user: second_user) }
      FactoryGirl.create(:free_gift, user: user)
      FactoryGirl.create(:gift_with_price, user: user)
      2.times { FactoryGirl.create(:gift_with_description, user: user) }
      2.times { FactoryGirl.create(:gift_with_url, user: user) }
    end

    it 'has 10 gifts' do
      expect(Gift.count).to eq(10)
    end

    describe 'when not logged in' do
      before { visit user_gifts_path(user) }

      it 'redirects to login page' do
        should have_current_path(login_path)
      end
    end

    describe 'when logged in' do
      before do
        login user
        click_link 'View Your Gifts'
      end

      it 'allows access' do
        should have_current_path(user_gifts_path(user))
      end

      it "lists current user's gifts" do
        Gift.where(user_id: user.id).each do |user_gift|
          within(:css, 'table') do
            should have_content(user_gift.name)
            should have_content(user_gift.price)
            should have_content(user_gift.description)

            if user_gift.url.nil?
              should_not have_link(user_gift.name)
            else
              should have_link(user_gift.name)
            end

            should have_css("a[href='#{ user_gifts_path(user, render_edit: user_gift.id) }']")
            should_not have_content('Purchased')
          end
        end
      end

      it "does not list other user's gifts" do
        Gift.where.not(user_id: user.id).each do |other_user_gift|
          within(:css, 'table') do
            should_not have_content(other_user_gift.name)
          end
        end
      end
    end
  end

  describe "viewing other user's gifts" do
    before do
      2.times { FactoryGirl.create(:gift, user: user) }
      FactoryGirl.create(:gift, user: second_user)
      FactoryGirl.create(:gift, user: third_user)
      FactoryGirl.create(:gift, user: second_user, purchased: true, purchaser_id: user.id)
      FactoryGirl.create(:gift, user: second_user, purchased: true, purchaser_id: third_user.id)
      FactoryGirl.create(:free_gift, user: second_user)
      FactoryGirl.create(:gift_with_price, user: second_user)
      FactoryGirl.create(:gift_with_description, user: second_user)
      FactoryGirl.create(:gift_with_url, user: second_user)
    end

    it 'has 10 gifts' do
      expect(Gift.count).to eq(10)
    end

    describe 'when not logged in' do
      before { visit user_gifts_path(second_user) }

      it 'redirects to login page' do
        should have_current_path(login_path)
      end
    end

    describe 'when logged in' do
      before do
        login user
        visit user_gifts_path(second_user)
      end

      it 'allows access' do
        should have_current_path(user_gifts_path(second_user))
      end

      it "lists expected user's gifts" do
        Gift.where(user_id: second_user.id).each do |user_gift|
          within(:css, 'table') do
            should have_content(user_gift.name)
            should have_content(user_gift.price)
            should have_content(user_gift.description)

            if user_gift.url.nil?
              should_not have_link(user_gift.name)
            else
              should have_link(user_gift.name)
            end

            should_not have_css("a[href='#{ user_gifts_path(user, render_edit: user_gift.id) }']")

            within(:css, "tr#gift_#{ user_gift.id }") do
              if !user_gift.purchased
                should have_link('Mark as Purchased')
                should_not have_link('Purchased by You')
                should_not have_content("Purchased by #{ user.fullname }")
              elsif user_gift.purchaser_id == user.id
                should_not have_link('Mark as Purchased')
                should have_link('Purchased by You')
                should_not have_content("Purchased by #{ user.fullname }")
              else
                should_not have_link('Mark as Purchased')
                should_not have_link('Purchased by You')
                should have_content("Purchased by #{ third_user.fullname }")
              end
            end
          end
        end
      end

      it "does not list other user's gifts" do
        Gift.where.not(user_id: second_user.id).each do |other_user_gift|
          within(:css, 'table') do
            should_not have_content(other_user_gift.name)
          end
        end
      end
    end
  end

  describe 'creating new gift' do
    describe 'with no prior gift' do
      let(:submit) { 'SAVE' }
      let(:cancel) { 'CANCEL' }

      describe 'when not logged in' do
        before { visit user_gifts_path(user, render_new: true) }

        it 'redirects to login page' do
          should have_current_path(login_path)
        end
      end

      describe 'when logged in as different user' do
        before do
          login user
          visit user_gifts_path(second_user, render_new: true)
        end

        it 'should not render new gift form' do
          should_not have_selector('tr#new_gift')
        end

        it 'should not have "ADD NEW GIFT" button' do
          should_not have_link('ADD NEW GIFT')
        end
      end

      describe 'when logged in' do
        before do
          login user
          click_link 'View Your Gifts'
          click_link 'ADD NEW GIFT'
        end

        describe 'with invalid name' do
          it 'does not add the gift to the system' do
            expect { click_button submit }.not_to change(Gift, :count)
          end

          it 'redirects to new view' do
            click_button submit
            should have_current_path(user_gifts_path(user, render_new: true))
          end
        end

        describe 'with valid information' do
          before { fill_in 'gift_name', with: 'New Gift' }

          it 'adds the gift to the system' do
            expect { click_button submit }.to change(Gift, :count).by(1)
          end

          it 'redirects to new view' do
            click_button submit
            should have_current_path(user_gifts_path(user, render_new: true))
          end
        end

        describe 'clicking cancel' do
          it 'does not add the gift to the system' do
            expect { click_link cancel }.not_to change(Gift, :count)
          end

          it 'redirects to user gifts page' do
            click_link cancel
            should have_current_path(user_gifts_path(user))
          end
        end
      end
    end

    describe 'with a prior gift' do
      let(:submit) { 'SAVE' }
      let(:cancel) { 'CANCEL' }

      before { FactoryGirl.create(:gift, user: user) }

      describe 'when not logged in' do
        before { visit user_gifts_path(user, render_new: true) }

        it 'redirects to login page' do
          should have_current_path(login_path)
        end
      end

      describe 'when logged in as different user' do
        before do
          login user
          visit user_gifts_path(second_user, render_new: true)
        end

        it 'should not render new gift form' do
          should_not have_selector('tr#new_gift')
        end

        it 'should not have "ADD NEW GIFT" button' do
          should_not have_link('ADD NEW GIFT')
        end
      end

      describe 'when logged in' do
        before do
          login user
          click_link 'View Your Gifts'
          click_link 'ADD NEW GIFT'
        end

        describe 'with invalid name' do
          it 'does not add the gift to the system' do
            expect { click_button submit }.not_to change(Gift, :count)
          end

          it 'redirects to new view' do
            click_button submit
            should have_current_path(user_gifts_path(user, render_new: true))
          end
        end

        describe 'with valid information' do
          before { fill_in 'gift_name', with: 'New Gift' }

          it 'adds the gift to the system' do
            expect { click_button submit }.to change(Gift, :count).by(1)
          end

          it 'redirects to new view' do
            click_button submit
            should have_current_path(user_gifts_path(user, render_new: true))
          end
        end

        describe 'clicking cancel' do
          it 'does not add the gift to the system' do
            expect { click_link cancel }.not_to change(Gift, :count)
          end

          it 'redirects to user gifts page' do
            click_link cancel
            should have_current_path(user_gifts_path(user))
          end
        end
      end
    end
  end

  describe 'editing gift' do
    let(:submit) { 'SAVE' }
    let(:cancel) { 'CANCEL' }
    let!(:new_gift) { FactoryGirl.create(:gift, user: user) }
    let!(:other_user_gift) { FactoryGirl.create(:gift, user: second_user) }

    describe 'when not logged in' do
      before { visit user_gifts_path(user, render_edit: new_gift.id) }

      it 'redirects to login page' do
        should have_current_path(login_path)
      end
    end

    describe 'when logged in as different user' do
      before do
        login user
        visit user_gifts_path(second_user, render_edit: other_user_gift.id)
      end

      it 'should not render edit gift form' do
        should_not have_selector('tr#edit_gift')
      end

      it 'should not have "ADD NEW GIFT" button' do
        should_not have_link('', href: user_gifts_path(second_user, render_edit: other_user_gift.id))
      end
    end

    describe 'when logged in' do
      before do
        login user
        click_link 'View Your Gifts'
        within(:css, "tr#gift_#{ new_gift.id }") do
          click_link('', href: user_gifts_path(user, render_edit: new_gift.id))
        end
      end

      describe 'with invalid name' do
        before { fill_in 'gift_name', with: '' }

        it 'does not change the data' do
          click_button submit
          expect(new_gift.name).to eq(new_gift.name)
        end

        it 'does not add a new gift to the system' do
          expect { click_button submit }.not_to change(Gift, :count)
        end
      end

      describe 'with valid information' do
        before { fill_in 'gift_name', with: 'newname' }

        it 'changes the data' do
          click_button submit
          expect(new_gift.name).not_to eq(new_gift.reload.name)
        end

        it 'does not add a new gift to the system' do
          expect { click_button submit }.not_to change(Gift, :count)
        end

        it 'redirects to user gifts page' do
          click_button submit
          should have_current_path(user_gifts_path(user))
        end
      end

      describe 'clicking cancel' do
        before { fill_in 'gift_name', with: 'newname' }

        it 'does not change the data' do
          click_link cancel
          expect(new_gift.name).to eq(new_gift.name)
        end

        it 'does not add a new gift to the system' do
          expect { click_button submit }.not_to change(Gift, :count)
        end

        it 'redirects to user gifts page' do
          click_button submit
          should have_current_path(user_gifts_path(user))
        end
      end
    end
  end

  describe 'marking as purchased' do
    let!(:first_user_gift) { FactoryGirl.create(:gift, user: user) }
    let!(:second_user_gift) { FactoryGirl.create(:gift, user: second_user) }
    let!(:purchased_gift) do
      FactoryGirl.create(:purchased_gift, user: second_user,
                         purchaser_id: third_user.id)
    end

    before { login user }

    describe 'when already purchased' do
      before { visit user_gifts_path(second_user) }

      it 'has the correct text' do
        within(:css, "tr#gift_#{ purchased_gift.id }") do
          should_not have_link('Mark as Purchased')
          should_not have_link('Purchased by You')
          should have_selector('td', text: "Purchased by #{ third_user.fullname }")
        end
      end
    end

    describe 'when not yet purchased' do
      before { visit user_gifts_path(second_user) }

      it 'has the correct button' do
        within(:css, "tr#gift_#{ second_user_gift.id }") do
          should have_link('Mark as Purchased')
          should_not have_content('Purchased by You')
          should_not have_selector('td', text: 'Purchased by')
        end
      end

      it 'changes the data' do
        click_link 'Mark as Purchased'
        expect(second_user_gift.reload.purchased).to be(true)
        expect(second_user_gift.reload.purchaser_id).to eq(user.id)
      end

      it 'does not add a new gift to the system' do
        expect { click_link 'Mark as Purchased' }.not_to change(Gift, :count)
      end

      it 'redirects to user gifts page' do
        click_link 'Mark as Purchased'
        should have_current_path(user_gifts_path(second_user))
      end
    end

    describe 'own gifts' do
      before { visit user_gifts_path(user) }

      it 'DOES NOT SHOW ANY PURCHASED INFORMATION' do
        within(:css, "tr#gift_#{ first_user_gift.id }") do
          should_not have_link('Mark as Purchased')
          should_not have_link('Purchased by You')
          should_not have_selector('li', text: 'Purchased by')
        end
      end
    end
  end

  describe 'marking as unpurchased' do
    let!(:gift_purchased_by_self) do
      FactoryGirl.create(:purchased_gift, user: second_user,
                         purchaser_id: user.id)
    end

    before do
      login user
      visit user_gifts_path(second_user)
    end

    it 'has the correct button' do
      within(:css, "tr#gift_#{ gift_purchased_by_self.id }") do
        should_not have_link('Mark as Purchased')
        should have_link('Purchased by You')
        should_not have_selector('Purchased by')
      end
    end

    it 'changes the data' do
      click_link 'Purchased by You'
      expect(gift_purchased_by_self.reload.purchased).to be(false)
      expect(gift_purchased_by_self.reload.purchaser_id).to be(nil)
    end

    it 'does not add a new gift to the system' do
      expect { click_link 'Purchased by You' }.not_to change(Gift, :count)
    end

    it 'redirects top user gifts page' do
      click_link 'Purchased by You'
      should have_current_path(user_gifts_path(second_user))
    end
  end

  describe 'deleting gift' do
    let!(:new_gift) { FactoryGirl.create(:gift, user: user) }

    before do
      login user
      click_link 'View Your Gifts'
    end

    it 'removes the gift from the system' do
      expect { click_link('', href: gift_path(new_gift)) }.to change(Gift, :count).by(-1)
    end

    it 'redirects to user gifts page' do
      click_link('', href: gift_path(new_gift))
      should have_current_path(user_gifts_path(user))
    end
  end
end