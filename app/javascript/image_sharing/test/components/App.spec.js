/* eslint-env mocha */

import assert from 'assert';
import { mount } from 'enzyme';
import React from 'react';
import App from '../../components/App';

describe('<App />', () => {
  it('should render correctly', () => {
    const wrapper = mount(<App />);
    assert(wrapper.find('Header').prop('title') === 'Tell us what you think');
  });

  it('form label and input field for name exists', () => {
    const wrapper = mount(<App />);
    assert(wrapper.find({ for: 'name' }).text() === 'Your Name');
    assert(wrapper.find('Input').find({ id: 'name' }).some({ name: 'name' }));
  });

  it('form label and input field for comment exists', () => {
    const wrapper = mount(<App />);
    assert(wrapper.find({ for: 'comments' }).text() === 'Comments');
    assert(wrapper.find('Input').find({ id: 'comments' }).some({ name: 'comments' }));
  });

  it('footer should render correctly', () => {
    const wrapper = mount(<App />);
    assert(wrapper.find('footer').text() === 'Copyright: Appfolio Inc. Onboarding');
  });
});
