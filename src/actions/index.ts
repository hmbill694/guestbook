import { defineAction } from 'astro:actions';
import { z } from 'astro/zod';
import { addMessage } from '../lib/db';

export const server = {
	addMessage: defineAction({
		accept: 'form',
		input: z.object({
			name: z.string({ error: 'Name is required' }).trim().min(1, 'Name is required').max(100),
			message: z.string({ error: 'Message is required' }).trim().min(1, 'Message is required').max(2000),
		}),
		handler: ({ name, message }) => {
			addMessage(name, message);
		},
	}),
};
