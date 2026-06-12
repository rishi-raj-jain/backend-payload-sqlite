import type { CollectionConfig } from 'payload'

export const Tags: CollectionConfig = {
  slug: 'tags',
  admin: { useAsTitle: 'name' },
  access: { read: ({ req: { user } }) => {
    // Return `true` if a user is found
    // and `false` if it is undefined or null
    return Boolean(user) 
  } },
  fields: [
    { name: 'name', type: 'text', required: true },
    {
      name: 'slug',
      type: 'text',
      required: true,
      admin: { description: 'URL-friendly identifier, e.g. web-performance' },
    },
  ],
}