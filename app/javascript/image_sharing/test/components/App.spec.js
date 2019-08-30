/* eslint-env mocha */

import assert from 'assert';
import { mount, shallow } from 'enzyme';
import React from 'react';
import sinon from 'sinon';
import App from '../../components/App';
import * as Helper from '../../utils/helper';

describe('<App />', () => {
  describe('constructor', () => {
    it('constructor initializes with empty form fields', () => {
      const wrapper = mount(<App />);
      const app = wrapper.instance();

      assert(app.state.name === '');
      assert(app.state.comment === '');
    });
  });

  describe('handleNameChange', () => {
    it('name form field updates name state', () => {
      const wrapper = shallow(<App />);
      const app = wrapper.instance();
      const event = {
        target: {
          value: 'test-name'
        }
      };
      app.handleNameChange(event);

      assert(app.state.name === 'test-name');
    });
  });

  describe('handleCommentChange', () => {
    it('comment form field updates comment state', () => {
      const wrapper = shallow(<App />);
      const app = wrapper.instance();
      const event = {
        target: {
          value: 'test-comment'
        }
      };
      app.handleCommentChange(event);

      assert(app.state.comment === 'test-comment');
    });
  });

  describe('handleSubmit', () => {
    const stub = sinon.stub(Helper, 'post');

    it('posts data to backend successfully', () => {
      //const stub = sinon.stub(Helper, 'post').returns(Promise.resolve());
      stub.returns(Promise.resolve());
      const wrapper = mount(<App />);
      const body = { name: 'test-name',
        comment: 'test-comment'
      };
      wrapper.setState(body);

      return wrapper.instance().handleSubmit().then(() => {
        sinon.assert.calledWith(stub, '/api/feedbacks', body);
        assert(wrapper.state('name') === '');
        assert(wrapper.state('comment') === '');
        assert(wrapper.state('postStatus') === 'success');
      });
    });

    it('failed post does not modify user input', () => {
      stub.returns(Promise.reject());
      const wrapper = mount(<App />);
      const body = { name: 'test-name',
        comment: 'test-comment'
      };
      wrapper.setState(body);

      return wrapper.instance().handleSubmit().then(() => {
        sinon.assert.calledWith(stub, '/api/feedbacks', body);
        assert(wrapper.state('name') === 'test-name');
        assert(wrapper.state('comment') === 'test-comment');
        assert(wrapper.state('postStatus') === 'failure');
      });
    });
  });

  describe('render', () => {
    it('should render correctly', () => {
      const wrapper = shallow(<App />);
      assert(wrapper.find('Header')
        .prop('title') === 'Tell us what you think');
    });

    it('form label and input field for name exists', () => {
      const wrapper = mount(<App />);
      assert(wrapper.find({ for: 'name' })
        .text() === 'Your Name');
      assert(wrapper.find('Input')
        .find({ id: 'name' })
        .some({ name: 'name' }));
    });

    it('form label and input field for comment exists', () => {
      const wrapper = mount(<App />);
      assert(wrapper.find({ for: 'comments' })
        .text() === 'Comments');
      assert(wrapper.find('Input')
        .find({ id: 'comments' })
        .some({ name: 'comments' }));
    });

    it('footer should render correctly', () => {
      const wrapper = shallow(<App />);
      assert(wrapper.find('footer')
        .prop('children') === 'Copyright: Appfolio Inc. Onboarding');
    });

    it('name form field updates with state', () => {
      const wrapper = shallow(<App />);
      wrapper.setState({ name: 'test-name' });

      assert.equal(wrapper.find('Input')
        .find({ id: 'name' })
        .prop('value'), 'test-name');
    });

    it('comment form field updates with state', () => {
      const wrapper = shallow(<App />);
      wrapper.setState({ comment: 'test-comment' });

      assert.equal(wrapper.find('Input')
        .find({ id: 'comments' })
        .prop('value'), 'test-comment');
    });

    it('display success message on successful submit', () => {
      const wrapper = shallow(<App />);
      wrapper.setState({ postStatus: 'success' });

      assert.equal(wrapper.find('Alert')
        .prop('color'), 'success');
      assert.equal(wrapper.find('Alert')
        .find({ color: 'success' })
        .prop('children'), 'Successfully submitted feedback.');
    });

    it('display failure message on failed submit', () => {
      const wrapper = shallow(<App />);
      wrapper.setState({ postStatus: 'failure' });

      assert.equal(wrapper.find('Alert')
        .prop('color'), 'danger');
      assert.equal(wrapper.find('Alert')
        .find({ color: 'danger' })
        .prop('children'), 'Failed to submit feedback.');
    });
  });
});
