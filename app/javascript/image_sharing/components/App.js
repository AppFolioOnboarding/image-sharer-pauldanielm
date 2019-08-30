import React from 'react';
import { Button, Form, FormGroup, Label, Input, Alert } from 'reactstrap';
import Header from './Header';
import { post } from '../utils/helper.js';

class App extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      name: '',
      comment: '',
      postStatus: ''
    };
  }

  handleNameChange = (event) => {
    this.setState({ name: event.target.value });
  }

  handleCommentChange = (event) => {
    this.setState({ comment: event.target.value });
  }

  handleSubmit = () => {
    const body = { name: this.state.name, comment: this.state.comment };

    return post('/api/feedbacks', body)
      .then(() => {
        this.setState({ name: '', comment: '', postStatus: 'success' });
      }).catch(() => {
        this.setState({ postStatus: 'failure' });
      });
  }

  render() {
    return (
      <div>
        {this.state.postStatus === 'success' ?
          <Alert color="success">Successfully submitted feedback.</Alert> : ''
        }
        {this.state.postStatus === 'failure' ?
          <Alert color="danger">Failed to submit feedback.</Alert> : ''
        }
        <Header title="Tell us what you think" />
        <Form>
          <FormGroup>
            <Label for="name">Your Name</Label>
            <Input
              type="text"
              name="name"
              id="name"
              value={this.state.name}
              onChange={this.handleNameChange}
            />
          </FormGroup>
          <FormGroup>
            <Label for="comments">Comments</Label>
            <Input
              type="textarea"
              name="comments"
              id="comments"
              value={this.state.comment}
              onChange={this.handleCommentChange}
            />
          </FormGroup>
          <Button onClick={this.handleSubmit}>Submit</Button>
          <footer>Copyright: Appfolio Inc. Onboarding</footer>
        </Form>
      </div>
    );
  }
}

export default App;

/* TODO: Add Prop Types check*/
