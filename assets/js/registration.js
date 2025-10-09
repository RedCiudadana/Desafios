import { supabase } from './supabase-client.js';

async function submitRegistration(formData) {
    try {
        const { data, error } = await supabase
            .from('challenge_registrations')
            .insert([
                {
                    name: formData.name,
                    email: formData.email,
                    phone: formData.phone,
                    participant_type: formData.type,
                    organization: formData.organization || null,
                    location: formData.location,
                    idea: formData.idea,
                    experience: formData.experience || null,
                    challenge_name: formData.challenge
                }
            ])
            .select();

        if (error) {
            console.error('Error submitting registration:', error);
            throw error;
        }

        return { success: true, data };
    } catch (error) {
        console.error('Registration error:', error);
        return { success: false, error: error.message };
    }
}

window.submitRegistration = submitRegistration;
